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
                AsyncImage(url: URL(string: imageURL(for: medicineName))) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 150)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity)
                            .padding(.top)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(12)

                    case .failure(_):
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)

                    @unknown default:
                        EmptyView()
                    }
                }

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
                scheduleNotification(for: medicineName, expirationDate: selectedDate)
                onSaved()
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

    private func saveExpiration() {
        let timestamp = selectedDate.timeIntervalSince1970
        UserDefaults.standard.set("\(timestamp)", forKey: "expiration_\(medicineName)")
    }

    private func scheduleNotification(for medicineName: String, expirationDate: Date) {
        guard !medicineName.isEmpty else {
            print("⚠️ Skipping notification — medicine name is empty")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Reminder for \(medicineName)"
        content.body = "This medicine expires soon — check your inventory!"
        content.sound = .default

        let reminderDate = Calendar.current.date(byAdding: .day, value: -7, to: expirationDate) ?? expirationDate
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder_\(medicineName)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Notification error: \(error.localizedDescription)")
            } else {
                print("✅ Reminder scheduled for \(medicineName) on \(reminderDate)")
            }
        }
    }


    private func getSavedExpiration() -> Date? {
        let components = expirationStorage.split(separator: "=")
        guard components.count == 2, components[0] == medicineName,
              let timestamp = Double(components[1]) else {
            return nil
        }
        return Date(timeIntervalSince1970: timestamp)
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func imageURL(for medicine: String) -> String {
        switch medicine {
        case "Advil": return "https://m.media-amazon.com/images/I/81-JFc-sotL._AC_UF1000,1000_QL80_.jpg"
        case "Theraflu": return "https://cdn.discount-drugmart.com/products/images/syndigo/e730a004-f954-4b6f-86cf-13f03864ddf2/600/20b4253e-90c4-4533-a6eb-155c58c99380.jpg"
        case "Tylenol": return "https://cdn.drugstore2door.com/catalog/product/cache/4c0d23783922484128e316257934ccaf/0/0/00300450449092_1_2.jpg"
        case "Zyrtec": return "https://cdn.discount-drugmart.com/products/images/syndigo/e730a004-f954-4b6f-86cf-13f03864ddf2/600/3fbe12ba-1d21-4deb-8930-0e61359f2c93.jpg"
        case "Ibuprofen": return "https://www.associatedbag.com/images/catalog/web266-9-08_400.jpg"
        case "Pepto Bismol": return "https://m.media-amazon.com/images/I/71nSMz337iL._AC_UF894,1000_QL80_.jpg"
        case "Claritin": return "https://i5.walmartimages.com/seo/Claritin-24-Hour-Non-Drowsy-Allergy-Medicine-Loratadine-Antihistamine-Tablets-10-Ct_32a6a546-8004-437a-afb2-2294a84f2f8f.f6a05a30e8f5835cd15fd2b00e4771af.jpeg"
        case "Tums": return "https://cdn.discount-drugmart.com/products/images/syndigo/e730a004-f954-4b6f-86cf-13f03864ddf2/600/167a9533-407e-4a32-90de-f499bfafcad6.jpg"
        case "Aspirin": return "https://www.aspirin.ca/sites/g/files/vrxlpx30151/files/2021-06/Aspirin-Regular-extra-strength-100ct-carton.png"
        case "Amoxicillin": return "https://www.poison.org/-/media/images/shared/articles/amoxicillin.jpg"
        case "Acetaminophen": return "https://athome.medline.com/media/catalog/product/cache/629a5912a555bf7b815eea5423d5ef47/o/t/otc802401_01_1.jpg"
        default: return ""
        }
    }
} 
