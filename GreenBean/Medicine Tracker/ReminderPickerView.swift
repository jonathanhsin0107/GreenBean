import SwiftUI
import UserNotifications

struct ReminderPickerView: View {
    let name: String
    @Binding var selectedDate: Date

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm
    @AppStorage("hasLoggedMedicine") private var hasLoggedMedicine: Bool = false

    // MARK: — Fun‑fact pools
    let sustainabilityFacts = [
        "Did you know? Recycling one aluminum can saves enough energy to run a TV for 3 hours!",
        "A single tree can absorb up to 48 pounds of carbon dioxide per year!"
    ]
    let ecoTips = [
        "Switch to LED bulbs to save energy and reduce your electricity bill.",
        "Use reusable shopping bags to help reduce plastic waste!"
    ]
    let greenHabits = [
        "Consider biking or walking instead of driving to reduce your carbon footprint.",
        "Composting helps reduce food waste and enriches your soil."
    ]
    let waterFacts = [
        "A hot water faucet that leaks one drop per second can add up to 165 gallons a month.",
        "An energy‑smart washer can save more water in one year than one person drinks in a lifetime."
    ]
    let energyFacts = [
        "Americans consume 26% of the world's energy but make up only 5% of the population.",
        "A compact fluorescent bulb uses 75% less energy than a regular bulb and can last up to four years."
    ]
    let wasteFacts = [
        "Recycling one ton of paper saves 7,000 gallons of water and three cubic yards of landfill space.",
        "Over 40% of U.S. municipal waste is paper—about 71.8 tons per year."
    ]

    // MARK: — Toggles & fields
    @State private var enableDaily = false
    @State private var enableExpiration = false
    @State private var enableInterval = false

    @State private var reminderTime = Date()
    @State private var selectedDurations: Set<Int> = []
    @State private var selectedInterval: Int = 3
    let timeIntervals = [3, 6, 8, 10]

    // MARK: — Category & preview
    @State private var selectedCategory = "Sustainability Facts"
    let categories = ["Sustainability Facts", "Eco Tips", "Green Habits", "Water", "Energy", "Waste"]
    @State private var previewFact: String = ""

    // MARK: — Confirmation alert
    @State private var showConfirmation = false
    @State private var confirmationMessage = ""

    var body: some View {
        NavigationView {
            Form {
                // 1️⃣ Reminder toggles
                Section(header: Text("Which reminders would you like?")) {
                    Toggle("Daily medication reminder", isOn: $enableDaily)
                    Toggle("Expiration-based reminders", isOn: $enableExpiration)
                    Toggle("Reminder every few hours", isOn: $enableInterval)
                }

                // 2️⃣ Daily Reminder
                if enableDaily {
                    Section(header: Text("Daily Reminder")) {
                        Text("Medicine: \(name)")
                        DatePicker("Time of Day",
                                   selection: $reminderTime,
                                   displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                    }
                }

                // 3️⃣ Expiration Reminders
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

                // 4️⃣ Interval Reminders
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

                // 5️⃣ Fun Fact Category
                Section(header: Text("Fun Fact Category")) {
                    Picker("Choose a category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // 6️⃣ Always‑visible Fun Fact Preview
                Section(header: Text("Fun Fact Preview")) {
                    Text(previewFact)
                        .italic()
                        .padding(.vertical, 4)
                }

                // 7️⃣ Schedule Button
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
            .onAppear {
                requestNotificationPermission()
                updatePreview()
            }
            .onChange(of: selectedCategory) { _ in
                updatePreview()
            }
        }
    }

    // MARK: — Preview updater
    private func updatePreview() {
        let pool: [String]
        switch selectedCategory {
        case "Eco Tips":     pool = ecoTips
        case "Green Habits": pool = greenHabits
        case "Water":        pool = waterFacts
        case "Energy":       pool = energyFacts
        case "Waste":        pool = wasteFacts
        default:             pool = sustainabilityFacts
        }
        previewFact = pool.randomElement() ?? ""
    }

    // MARK: — Schedule all reminders
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
        scheduleFunFactNotification()

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

    // MARK: — Notification permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    // MARK: — Daily reminder
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

    // MARK: — Interval reminder
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

    // MARK: — Expiration reminder
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

    // MARK: — Fun‑fact notification
    private func scheduleFunFactNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🌍 Fun Fact!"

        let pool: [String]
        switch selectedCategory {
        case "Eco Tips":     pool = ecoTips
        case "Green Habits": pool = greenHabits
        case "Water":        pool = waterFacts
        case "Energy":       pool = energyFacts
        case "Waste":        pool = wasteFacts
        default:             pool = sustainabilityFacts
        }

        content.body = pool.randomElement() ?? "Did you know that every small action counts in saving the planet?"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6 * 3600, repeats: true)
        let id = "fun_fact_reminder"

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error { print("Fun fact schedule error: \(e.localizedDescription)") }
        }
    }
}
