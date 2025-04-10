import SwiftUI
import UserNotifications

struct MedicineDetailView: View {
    let name: String
    let imageUrl: String
    let info: String

    @AppStorage("loggedMedicines") private var storedMedicineString: String = ""
    @AppStorage("rewardPoints") private var rewardPoints: Int = 0

    @State private var savedExpirationDate: String = ""
    @State private var selectedDate = Date()
    @State private var showReminderSheet = false
    @State private var showThankYou = false
    @State private var showDeleteConfirm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // 🧪 Test Notification Button
                Button(action: {
                    scheduleTestNotification()
                }) {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                        Text("Test Notification")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(12)
                }

                // Medicine image
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }

                // Info section
                Text(name)
                    .font(.title)
                    .bold()

                Text("💬 General Information")
                    .font(.headline)

                Text(info)
                    .font(.body)
                    .foregroundColor(.secondary)

                // Expiration date
                VStack(alignment: .leading, spacing: 12) {
                    Text("📅 Log Expiration Date")
                        .font(.headline)

                    DatePicker("Select Expiration", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)

                    Button("Log Medicine") {
                        savedExpirationDate = formatted(date: selectedDate)
                        UserDefaults.standard.set(savedExpirationDate, forKey: "expiration_\(name)")

                        scheduleReminderBeforeExpiration(medicineName: name, expirationDate: selectedDate, monthsBefore: 1)

                        if !storedMedicineString.contains(name) {
                            storedMedicineString += storedMedicineString.isEmpty ? name : "|\(name)"
                            rewardPoints += 50
                            showThankYou = true
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)

                    if !savedExpirationDate.isEmpty {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Logged: \(savedExpirationDate)")
                        }
                        .foregroundColor(.gray)
                    }
                }
                .padding(.top)

                // Reminders and delete
                HStack(spacing: 20) {
                    Button {
                        showReminderSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("Set Reminder")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(12)
                    }

                    Button {
                        showDeleteConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Remove Log")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(12)
                    }
                }
                .foregroundColor(.primary)
                .padding(.top)

                Spacer()
            }
            .padding()
        }
        .navigationTitle(name)
        .sheet(isPresented: $showReminderSheet) {
            ReminderPickerView(name: name, selectedDate: $selectedDate)
        }
        .alert(isPresented: $showThankYou) {
            Alert(
                title: Text("🎉 Logged!"),
                message: Text("Thank you for logging your medicine! You're helping reduce waste."),
                dismissButton: .default(Text("Nice!"))
            )
        }
        .alert(isPresented: $showDeleteConfirm) {
            Alert(
                title: Text("Remove Log?"),
                message: Text("Are you sure you want to remove this medicine log?"),
                primaryButton: .destructive(Text("Remove"), action: removeLog),
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            savedExpirationDate = UserDefaults.standard.string(forKey: "expiration_\(name)") ?? ""

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                print(granted ? "✅ Permissions granted (onAppear)" : "❌ Permission denied")
                if let error = error {
                    print("❌ Permission error: \(error)")
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func removeLog() {
        let current = storedMedicineString
            .components(separatedBy: "|")
            .filter { !$0.isEmpty && $0 != name }
        storedMedicineString = current.joined(separator: "|")
        UserDefaults.standard.removeObject(forKey: "expiration_\(name)")
        savedExpirationDate = ""
    }

    private func scheduleReminderBeforeExpiration(medicineName: String?, expirationDate: Date, monthsBefore: Int) {
        guard let medicineName = medicineName, !medicineName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("⚠️ Skipping reminder — medicine name is nil or empty")
            return
        }

        print("🧪 Scheduling reminder: \(medicineName) | Exp: \(expirationDate) | \(monthsBefore) months before")

        guard let reminderDate = Calendar.current.date(byAdding: .month, value: -monthsBefore, to: expirationDate) else {
            print("⚠️ Couldn’t compute reminder date.")
            return
        }

        let finalDate = reminderDate < Date() ? Date().addingTimeInterval(5) : reminderDate

        let content = UNMutableNotificationContent()
        content.title = "💊 Expiring Soon"
        content.body = "Your \(medicineName) is expiring in \(monthsBefore) month\(monthsBefore == 1 ? "" : "s"). Check it now!"
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: finalDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: "expire_\(medicineName)_\(monthsBefore)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling: \(error.localizedDescription)")
            } else {
                print("✅ Reminder scheduled for \(medicineName) at \(finalDate)")
            }
        }

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("🔔 Pending notifications: \(requests.count)")
            for req in requests {
                print("• \(req.identifier): \(req.content.title)")
            }
        }
    }

    private func scheduleTestNotification() {
        print("🧪 Test Notification Function Called!")

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        let content = UNMutableNotificationContent()
        content.title = "🧪 Test Works!"
        content.body = "If you're seeing this, everything is working 🎉"
        content.sound = UNNotificationSound.defaultCritical

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "test_notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule test: \(error.localizedDescription)")
            } else {
                print("✅ Test notification scheduled to appear in 5 seconds")
            }
        }
    
    }
}
