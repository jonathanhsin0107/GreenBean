import SwiftUI
import UserNotifications

struct ExpirationEntryView: View {
    let medicineName: String
    var onSaved: () -> Void
    @Binding var selectedDate: Date
    @AppStorage("expirations") private var expirationStorage: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(spacing: 12) {
                Image(imageName(for: medicineName))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    .padding(.top)

                Text(medicineName)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)

            Divider()

            Text("📅 Log Expiration Date")
                .font(.headline)

            DatePicker("Select Expiration", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)

            Button("Save Expiration") {
                saveExpiration()
                onSaved()
                
                // Schedule after state updates
                DispatchQueue.main.async {
                    scheduleNotification(for: medicineName, expirationDate: selectedDate)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)

            if let savedDate = getSavedExpiration() {
                Text("📋 Logged: \(formatted(date: savedDate))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Set Expiration")
    }

    private func saveExpiration() {     // Save expiration as timestamp
        let timestamp = selectedDate.timeIntervalSince1970
        UserDefaults.standard.set("\(timestamp)", forKey: "expiration_\(medicineName)")
    }

    // Schedule a reminder notification
    private func scheduleNotification(for medicineName: String, expirationDate: Date) {
        guard !medicineName.isEmpty else {
            print("⚠️ Skipping notification — medicine name is empty")
            return
        }

        let reminderDate = Calendar.current.date(byAdding: .month, value: -1, to: expirationDate) ?? expirationDate
        let now = Date()
        guard reminderDate > now else {
            print("⚠️ Reminder date is in the past — not scheduling.")
            return
        }

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let content = UNMutableNotificationContent()
        
        content.title = "Reminder for \(medicineName)"
        content.body = "This medicine expires soon — check your inventory!"
        content.sound = .default

        let identifier = "reminder_\(medicineName)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Reminder scheduled for \(medicineName) on \(reminderDate)")
                print("🗓️ Expiration date: \(expirationDate)")
                print("📆 Today is: \(Date())")
            }
        }
    }

    private func getSavedExpiration() -> Date? {        // Load saved expiration timestamp
        if let timestampStr = UserDefaults.standard.string(forKey: "expiration_\(medicineName)"),
           let timestamp = Double(timestampStr) {
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }

    private func formatted(date: Date) -> String {        // Format date to readable string
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func imageName(for medicine: String) -> String {
        switch medicine {
        case "Advil": return "advil_picture"
        case "Theraflu": return "theraflu_picture"
        case "Tylenol": return "tylenol_picture"
        case "Zyrtec": return "zyrtec_picture"
        case "Ibuprofen": return "ibuprofen_picture"
        case "Pepto Bismol": return "pepto_bismol_picture"
        case "Claritin": return "claritin_picture"
        case "Tums": return "tums_picture"
        case "Aspirin": return "aspirin_picture"
        case "Amoxicillin": return "amoxicillin_picture"
        case "Acetaminophen": return "acetaminophen_picture"
        default: return "ImageUnavailable" // fallback if no matching image
        }
    }
}
