import SwiftUI

struct MedicineTrackerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("💊 Welcome to Your Tracker")
                    .font(.title)
                    .bold()

                NavigationLink(destination: MedicineSelectionView()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Log New Medicine")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(12)
                }

                NavigationLink(destination: LoggedMedicinesView()) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("View Logged Medicines")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                }

                // Your sustainability champion note
                Text("🌿 By reducing medicine wastage, you're helping prevent harmful chemicals from entering our water systems. Thank you for being a sustainability champion!")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Medicine Tracker")
    }
}

#Preview {
    NavigationView {
        MedicineTrackerView()
    }
}
