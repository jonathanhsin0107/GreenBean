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

                // Expiration entry
                VStack(alignment: .leading, spacing: 12) {
                    Text("📅 Log Expiration Date")
                        .font(.headline)

                    DatePicker("Select Expiration", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)

                    Button("Log Medicine") {
                        savedExpirationDate = formatted(date: selectedDate)
                        UserDefaults.standard.set(savedExpirationDate, forKey: "expiration_\(name)")

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

                // Buttons for reminder + delete
                HStack(spacing: 20) {
                    Button(action: {
                        showReminderSheet = true
                    }) {
                        HStack {
                            Image(systemName: "bell.fill")
                            Text("Set Reminder")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(12)
                    }

                    Button(action: {
                        showDeleteConfirm = true
                    }) {
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
            // ✅ Correct binding used here!
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
        }
    }

    // MARK: - Helpers

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // consistent across app
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
}
