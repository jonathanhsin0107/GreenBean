import SwiftUI
import UserNotifications

struct ReminderPickerView: View {
    var name: String? = nil
    @Binding var selectedDate: Date
    //@AppStorage("rewardPoints") private var rewardPoints: Int = 0
    @AppStorage("hasLoggedMedicine") private var hasLoggedMedicine: Bool = false
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm

    @State private var reminderTime = Date()
    @State private var selectedDurations: Set<Int> = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var testReminder = false

    @State private var showConfirmation = false
    @State private var confirmationMessage = ""

    init(name: String? = nil, selectedDate: Binding<Date> = .constant(Date())) {
        self.name = name
        self._selectedDate = selectedDate
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let medicineName = name {
                    // Daily Time-Based Reminder (Medicine-specific)
                    Form {
                        Section(header: Text("Reminder Details")) {
                            Text("Medicine: \(medicineName)")
                            DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                        }

                        Section {
                            Button("Schedule Reminder") {
                                scheduleMedicineNotification(medicineName: medicineName)
//                                rewardPoints += 100
                                confirmationMessage = "You’ve earned 100 points for setting a daily reminder for \(medicineName)!"
                                showConfirmation = true
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.blue)
                        }
                    }
                    .navigationTitle("Set Medication Reminder")
                    .navigationBarItems(trailing: Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    })

                } else {
                    // General Inventory Reminder (1/3/6 months from now)
                    VStack(spacing: 16) {
                        Text("Set a Reminder")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Choose when you'd like to be reminded to check your medicine inventory.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button(action: {
                            if testReminder {
                                testReminder = false
                            } else {
                                testReminder = true
                            }
                        }) {
                            HStack {
                                Text("Remind me 10 seconds from now")
                                    .fontWeight(.medium)
                                Spacer()
                                Image(systemName: testReminder ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(testReminder ? .green : .gray)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                        }
                        ForEach([6, 3, 1], id: \.self) { months in
                            Button(action: {
                                if selectedDurations.contains(months) {
                                    selectedDurations.remove(months)
                                } else {
                                    selectedDurations.insert(months)
                                }
                            }) {
                                HStack {
                                    Text("Remind me \(months) month\(months == 1 ? "" : "s") before expiration")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Image(systemName: selectedDurations.contains(months) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedDurations.contains(months) ? .green : .gray)
                                }
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        
                        Button("Set Reminders") {
                            for months in selectedDurations {
                                scheduleGeneralReminder(inMonths: months)
                            }
                            //rewardPoints += 100
                            //confirmationMessage = "You’ve earned 100 points for setting inventory reminders!"
                            if !hasLoggedMedicine {
                                rewardsAlgo.addPoints(100)
                                hasLoggedMedicine = true
                                confirmationMessage = "You’ve earned 100 points for your first log!"
                            } else {
                                confirmationMessage = "Your reminder for this log has been set"
                                if testReminder {
                                    scheduleTestNotification()
                                }
                                
                                showConfirmation = true
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background((selectedDurations.isEmpty && !testReminder) ? Color.gray.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(selectedDurations.isEmpty && !testReminder)

                        Spacer()
                    }
                    .padding()
                }
            }
            .onAppear {
                requestNotificationPermission()
            }
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("🎉 Reminder Set!"),
                    message: Text(confirmationMessage),
                    dismissButton: .default(Text("Awesome")) {
                        dismiss()
                    }
                )
            }
        }
    }
        

    // MARK: - Permissions

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print(granted ? "✅ Notifications allowed" : "❌ Notifications denied")
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Medicine-Specific Reminder (Daily)

    private func scheduleMedicineNotification(medicineName: String) {
        let content = UNMutableNotificationContent()
        content.title = "💊 Reminder"
        content.body = "Time to take your \(medicineName) medication!"
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "medication_\(medicineName)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling daily reminder: \(error)")
            } else {
                print("✅ Daily reminder scheduled for \(components)")
            }
        }
    }

    // MARK: - General Reminder in X Months

    private func scheduleGeneralReminder(inMonths months: Int) {
        let content = UNMutableNotificationContent()
        content.title = "💊 Inventory Reminder"
        content.body = "Time to check your medicine inventory and avoid waste!"
        content.sound = .default

        if let futureDate = Calendar.current.date(byAdding: .month, value: months, to: Date()) {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: futureDate)
            components.hour = 9
            components.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            let request = UNNotificationRequest(
                identifier: "inventoryCheck_\(UUID().uuidString)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling inventory reminder: \(error)")
                } else {
                    print("📅 Reminder scheduled for \(futureDate) (\(months) months later)")
                }
            }
        } else {
            print("⚠️ Could not calculate future date for \(months) months.")
        }
    }
    private func scheduleTestNotification() {
        print("🧪Test Notification Function Called!")
        let content = UNMutableNotificationContent()
        content.title = "🧪 Medicine reminder!"
        content.body = "If you're seeing this, everything is working 🎉"
        content.sound = UNNotificationSound.defaultCritical
        
        Task{
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let uuidString = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            do{
                try await UNUserNotificationCenter.current().add(request)
                print("✅ Test notification scheduled to appear in 10 seconds")
            }
            catch{
                print("❌ Failed to schedule test: \(error.localizedDescription)")
            }
        }
    
    }
}
