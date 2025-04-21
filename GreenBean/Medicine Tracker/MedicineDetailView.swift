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
                // Test notification button
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

                // Medicine info
                Text(name)
                    .font(.title)
                    .bold()

                Text("💬 General Information")
                    .font(.headline)
                Text(info)
                    .font(.body)
                    .foregroundColor(.secondary)

                // Expiration logging
                VStack(alignment: .leading, spacing: 12) {
                    Text("📅 Log Expiration Date")
                        .font(.headline)

                    DatePicker("Select Expiration", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)

                    Button("Log Medicine") {
                        savedExpirationDate = formatted(date: selectedDate)
                        UserDefaults.standard.set(savedExpirationDate, forKey: "expiration_\(name)")
                        // Schedule default 1-month-before reminder
                        scheduleReminderBeforeExpiration(
                            medicineName: name,
                            expirationDate: selectedDate,
                            monthsBefore: 1
                        )

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

                // Reminder and remove log buttons
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
                .environmentObject(RewardsAlgorithm())
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
                print(granted ? "✅ Permissions granted" : "❌ Permission denied")
                if let error = error {
                    print("Permission error: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Reminder Scheduling
    private func scheduleReminderBeforeExpiration(
        medicineName: String,
        expirationDate: Date,
        monthsBefore: Int
    ) {
        guard let reminderDate = Calendar.current.date(
            byAdding: .month,
            value: -monthsBefore,
            to: expirationDate
        ) else {
            print("⚠️ Could not compute reminderDate")
            return
        }

        let trigger: UNNotificationTrigger
        if reminderDate < Date() {
            // immediate fallback
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        } else {
            var comps = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: reminderDate
            )
            comps.hour = 9; comps.minute = 0; comps.second = 0
            trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        }

        let content = UNMutableNotificationContent()
        content.title = "💊 Expiring Soon"
        content.body  = "\(medicineName) expires in \(monthsBefore) month\(monthsBefore>1 ? "s" : "")!"
        content.sound = .default

        let identifier = "expire_\(medicineName)_\(monthsBefore)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])

        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        ) { error in
            if let error = error {
                print("❌ Scheduling error: \(error.localizedDescription)")
            } else {
                print("✅ Scheduled \(identifier) for",
                      reminderDate < Date() ? "in 5s (test)" : "\(reminderDate)")
            }

            // Debug prints
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("🗓 Pending (\(requests.count)):", requests.map(\.identifier))
            }
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("🔔 Authorization:", settings.authorizationStatus)
            }
        }
    }

    private func scheduleTestNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        let content = UNMutableNotificationContent()
        content.title = "🧪 Test Works!"
        content.body  = "If you're seeing this, everything is working 🎉"
        content.sound = .defaultCritical

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

    private func removeLog() {
        let current = storedMedicineString
            .split(separator: "|")
            .map(String.init)
            .filter { $0 != name }
        storedMedicineString = current.joined(separator: "|")
        UserDefaults.standard.removeObject(forKey: "expiration_\(name)")
        savedExpirationDate = ""
    }

    private func formatted(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt.string(from: date)
    }
}
