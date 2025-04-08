import SwiftUI
import UserNotifications

struct ReminderPickerView: View {
    var name: String? = nil
    @Binding var selectedDate: Date
    @AppStorage("rewardPoints") private var rewardPoints: Int = 0

    @State private var reminderTime = Date()
    @State private var selectedDurations: Set<Int> = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss

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
                                rewardPoints += 100
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

                        ForEach([6, 3, 1], id: \.self) { months in
                            Button(action: {
                                if selectedDurations.contains(months) {
                                    selectedDurations.remove(months)
                                } else {
                                    selectedDurations.insert(months)
                                }
                            }) {
                                HStack {
                                    Text("Remind me in \(months) month\(months == 1 ? "" : "s")")
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
                            rewardPoints += 100
                            confirmationMessage = "You’ve earned 100 points for setting inventory reminders!"
                            showConfirmation = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedDurations.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(selectedDurations.isEmpty)

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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            print(granted ? "✅ Notifications allowed" : "❌ Notifications denied")
        }
    }

    // MARK: - Medicine-Specific Reminder

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

        UNUserNotificationCenter.current().add(request)
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
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)
            print("📅 Reminder set for \(months) months later: \(futureDate)")
        }
    }
}
