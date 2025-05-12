import SwiftUI
import UserNotifications

struct ReminderPickerView: View {
    let name: String
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm
    @AppStorage("hasLoggedMedicine") private var hasLoggedMedicine: Bool = false
    
    // Toggles & fields
    @State private var enableDaily = false
    @State private var enableExpiration = false
    @State private var enableInterval = false

    @State private var reminderTime = Date()
    @State private var selectedDurations: Set<Int> = []
    @State private var selectedInterval: Int = 3
    let timeIntervals = [3, 6, 8, 10]

    // Category & preview
    @State private var selectedCategory = "Sustainability Facts"
    let categories = ["Sustainability Facts", "Eco Tips", "Green Habits", "Water", "Energy", "Waste"]
    @State private var previewFact: String = ""

    // Confirmation alert
    @State private var showConfirmation = false
    @State private var confirmationMessage = ""

    var body: some View {
        NavigationView {
            Form {
                // Reminder toggles
                Section(header: Text("Which reminders would you like?")) {
                    Toggle("Daily medication reminder", isOn: $enableDaily)
                    Toggle("Expiration-based reminders", isOn: $enableExpiration)
                    Toggle("Reminder every few hours", isOn: $enableInterval)
                }

                // Daily Reminder
                if enableDaily {
                    Section(header: Text("Daily Reminder")) {
                        Text("Medicine: \(name)")
                        DatePicker("Time of Day",
                                   selection: $reminderTime,
                                   displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                    }
                }

                // Expiration Reminders
                if enableExpiration {
                    Section(header: Text("Expiration Reminders")) {
                        ForEach([1, 3, 6], id: \.self) { months in
                            Toggle(
                                "Remind me \(months) month\(months > 1 ? "s" : "") before expiration",
                                isOn: Binding(
                                    get: { selectedDurations.contains(months) },
                                    set: { isOn in
                                        if isOn { selectedDurations.insert(months) }
                                        else    { selectedDurations.remove(months) }
                                    }
                                )
                            )
                        }
                    }
                }

                // Interval Reminders
                if enableInterval {
                    Section(header: Text("Interval Reminders")) {
                        Picker("Select interval", selection: $selectedInterval) {
                            ForEach(timeIntervals, id: \.self) { hrs in
                                Text("\(hrs) hours").tag(hrs)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }


                // Schedule Button
                Section {
                    Button("Schedule Reminders", action: scheduleAllReminders)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .disabled(!enableDaily && !enableExpiration && !enableInterval)
                }
            }
            .navigationTitle("Set Medication Reminders")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("🎉 Success!"),
                    message: Text(confirmationMessage),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }


    // Schedule all reminders
    private func scheduleAllReminders() {
        if enableDaily {
            scheduleDailyReminder()
        }
        if enableExpiration {
            for months in selectedDurations {
                scheduleExpirationReminder(monthsBefore: months)
            }
        }
        if enableInterval {
            scheduleIntervalReminder(interval: selectedInterval)
        }

        // Always schedule the fun‑fact notification
        ///scheduleFunFactNotification()

        // Award rewards points
        if !hasLoggedMedicine {
            rewardsAlgo.addPoints(100)
            hasLoggedMedicine = true
            confirmationMessage = "You’ve earned 100 points for setting your first reminder!"
        } else {
            confirmationMessage = "Your reminders have been scheduled!"
        }
        showConfirmation = true
    }

    // Notification permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    // Daily reminder
    private func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "💊 Time to take \(name)"
        content.body = "It's time for your daily dose of \(name)."
        content.sound = .default

        let comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let id = "daily_\(name)"

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error { print("Daily schedule error: \(e.localizedDescription)") }
        }
    }

    // Interval reminder
    private func scheduleIntervalReminder(interval: Int) {
        let content = UNMutableNotificationContent()
        content.title = "💊 Time to take \(name)"
        content.body = "It’s time to take your \(name) every \(interval) hours."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval * 3600), repeats: true)
        let id = "interval_\(name)_\(interval)"

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error { print("Interval schedule error: \(e.localizedDescription)") }
        }
    }

    // Expiration reminder
    private func scheduleExpirationReminder(monthsBefore: Int) {
        guard let reminderDate = Calendar.current.date(
            byAdding: .month, value: -monthsBefore, to: selectedDate
        ) else { return }

        let trigger: UNNotificationTrigger
        
        if reminderDate < Date() {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        } else {
            var comps = Calendar.current.dateComponents([.year, .month, .day], from: reminderDate)
            comps.hour = 9; comps.minute = 0; comps.second = 0
            trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        }

        let content = UNMutableNotificationContent()
        content.title = "💊 Expiring Soon"
        content.body = "Your \(name) is expiring in \(monthsBefore) month\(monthsBefore > 1 ? "s" : "")."
        content.sound = .default

        let id = "expire_\(name)_\(monthsBefore)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error { print("Expiration schedule error: \(e.localizedDescription)") }
        }
    }
}
