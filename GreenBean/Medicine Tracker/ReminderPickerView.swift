import SwiftUI
import UserNotifications

struct ReminderPickerView: View {
    let name: String
    @Binding var selectedDate: Date

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm
    @AppStorage("hasLoggedMedicine") private var hasLoggedMedicine: Bool = false

    // Fun facts about sustainability, eco tips, and green habits
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
    
    // Facts for other categories
    let waterFacts = [
        "A hot water faucet that leaks one drop per second can add up to 165 gallons a month. That's more than one person uses in two weeks.",
        "An energy-smart clothes washer can save more water in one year than one person drinks in an entire lifetime.",
        "An automatic dishwasher uses less hot water than doing dishes by hand -- an average of six gallons less, or more than 2,000 gallons per year.",
        "An American family of four uses up to 260 gallons of water in the home per day.",
        "Running tap water for two minutes is equal to 3-5 gallons of water.",
        "A 5-minute shower is equal to 20-35 gallons of water.",
        "A full bath is equal to approximately 60 gallons of water.",
        "Water efficient fixtures can cut water use by 30 percent."
    ]
    
    let energyFacts = [
        "Although accounting for only 5 percent of the world's population, Americans consume 26 percent of the world's energy.",
        "America uses about 15 times more energy per person than the typical developing country.",
        "A heavy coat of dust on a light bulb can block up to half of the light.",
        "When you turn on an incandescent light bulb, only 10% of the electricity used is turned into light. The other 90% is wasted as heat.",
        "A compact fluorescent light bulb uses 75 percent less energy than a regular bulb and it can last up to four years.",
        "A crack as small as 1/16th of an inch around a window frame can let in as much cold air as leaving the window open three inches.",
        "Some new refrigerators are so energy-smart they use less electricity than a light bulb.",
        "Every time you open the refrigerator door, up to 30 percent of the cold air can escape.",
        "Every year, more than $13 billion worth of energy leaks from houses through small holes and cracks. That's more than $150 per family.",
        "Office buildings use approximately 19 percent of all energy consumed in the United States.",
        "Heating, ventilating and air conditioning systems account for 40-60 percent of total energy use in the commercial sector."
    ]
    
    let wasteFacts = [
        "A single-sided, 10-page letter costs $.55 to mail. If copied on both sides, the letter uses only five sheets and costs only $.34 to mail.",
        "One ton of 100 percent recycled paper saves the equivalent of 4,100 kWh of energy, 7,000 gallons of water, 60 pounds of air emissions and three cubic yards of landfill space.",
        "In the United States, more than 40 percent of municipal solid waste is paper -- about 71.8 tons a year."
    ]

    // MARK: - Selection Toggles
    @State private var enableDaily = false
    @State private var enableExpiration = false
    @State private var enableInterval = false // For interval reminders

    // MARK: - Daily fields
    @State private var reminderTime = Date()

    // MARK: - Expiration fields
    @State private var selectedDurations: Set<Int> = []

    // MARK: - Interval fields
    @State private var selectedInterval: Int = 3 // Default interval is 3 hours
    let timeIntervals = [3, 6, 8, 10] // Predefined time intervals in hours

    // MARK: - Fun Fact Category
    @State private var selectedCategory = "Sustainability Facts"
    let categories = ["Sustainability Facts", "Eco Tips", "Green Habits", "Water", "Energy", "Waste"]

    // Confirmation
    @State private var showConfirmation = false
    @State private var confirmationMessage = ""

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Mode Picker
                Section(header: Text("Which reminders would you like?")) {
                    Toggle("Daily medication reminder", isOn: $enableDaily)
                    Toggle("Expiration-based reminders", isOn: $enableExpiration)
                    Toggle("Reminder every few hours", isOn: $enableInterval) // Interval picker
                }

                // MARK: - Daily Section
                if enableDaily {
                    Section(header: Text("Daily Reminder")) {
                        Text("Medicine: \(name)")
                        DatePicker("Time of Day", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                    }
                }

                // MARK: - Expiration Section
                if enableExpiration {
                    Section(header: Text("Expiration Reminders")) {
                        ForEach([1, 3, 6], id: \.self) { months in
                            Toggle(
                                "Remind me \(months) month\(months > 1 ? "s" : "") before expiration",
                                isOn: Binding(
                                    get: { selectedDurations.contains(months) },
                                    set: { isOn in
                                        if isOn { selectedDurations.insert(months) }
                                        else { selectedDurations.remove(months) }
                                    }
                                )
                            )
                        }
                    }
                }

                // MARK: - Interval Section
                if enableInterval {
                    Section(header: Text("Interval Reminders")) {
                        Picker("Select interval", selection: $selectedInterval) {
                            ForEach(timeIntervals, id: \.self) { interval in
                                Text("\(interval) hours")
                                    .tag(interval)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }

                // MARK: - Category Section
                Section(header: Text("Fun Fact Category")) {
                    Picker("Choose your reminder type", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // MARK: - Schedule Button
                Section {
                    Button(action: scheduleAllReminders) {
                        Text("Schedule Reminders")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(!enableDaily && !enableExpiration && !enableInterval) // Disable if nothing selected
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
            .onAppear(perform: requestNotificationPermission)
        }
    }

    // MARK: - Action
    private func scheduleAllReminders() {
        // Daily reminder
        if enableDaily {
            scheduleDailyReminder()
        }
        // Expiration reminder
        if enableExpiration {
            for months in selectedDurations {
                scheduleExpirationReminder(monthsBefore: months)
            }
        }
        // Interval reminder
        if enableInterval {
            scheduleIntervalReminder(interval: selectedInterval)
        }

        // Schedule fun fact notifications
        scheduleFunFactNotification()

        // Rewards
        if !hasLoggedMedicine {
            rewardsAlgo.addPoints(100)
            hasLoggedMedicine = true
            confirmationMessage = "You’ve earned 100 points for setting your first reminder!"
        } else {
            confirmationMessage = "Your reminders have been scheduled!"
        }
        showConfirmation = true
    }

    // MARK: - Permissions
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    // MARK: - Daily Scheduling
    private func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "💊 Time to take \(name)"
        content.body = "It's time for your daily dose of \(name)."
        content.sound = .default

        var comps = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)

        let id = "daily_\(name)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error { print("Daily schedule error: \(e.localizedDescription)") }
        }
    }

    // MARK: - Interval Scheduling
    private func scheduleIntervalReminder(interval: Int) {
        let content = UNMutableNotificationContent()
        content.title = "💊 Time to take \(name)"
        content.body = "It’s time to take your \(name) every \(interval) hours."
        content.sound = .default

        let intervalInSeconds = TimeInterval(interval * 3600) // Convert hours to seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalInSeconds, repeats: true)

        let id = "interval_\(name)_\(interval)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error { print("Interval schedule error: \(e.localizedDescription)") }
        }
    }

    // MARK: - Expiration Scheduling
    private func scheduleExpirationReminder(monthsBefore: Int) {
        guard let reminderDate = Calendar.current.date(
            byAdding: .month, value: -monthsBefore, to: selectedDate
        ) else { return }

        let trigger: UNNotificationTrigger
        if reminderDate < Date() {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        } else {
            var comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderDate)
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

    // MARK: - Fun Fact Scheduling
    private func scheduleFunFactNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🌍 Fun Fact!"
        
        // Pick the category based on the user's selection
        var funFacts: [String]
        
        switch selectedCategory {
        case "Eco Tips":
            funFacts = ecoTips
        case "Green Habits":
            funFacts = greenHabits
        case "Water":
            funFacts = waterFacts
        case "Energy":
            funFacts = energyFacts
        case "Waste":
            funFacts = wasteFacts
        default:
            funFacts = sustainabilityFacts
        }
        
        content.body = funFacts.randomElement() ?? "Did you know that every small action counts in saving the planet?"
        content.sound = .default

        // Set the notification to trigger every 6 hours
        let intervalInSeconds: TimeInterval = 6 * 3600  // 6 hours in seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalInSeconds, repeats: true)

        let id = "fun_fact_reminder"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id]) // Remove previous reminders
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        ) { error in
            if let e = error {
                print("Fun fact schedule error: \(e.localizedDescription)")
            }
        }
    }
}
