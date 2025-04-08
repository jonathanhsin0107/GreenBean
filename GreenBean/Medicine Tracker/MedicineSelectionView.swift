import SwiftUI

struct MedicineSelectionView: View {
    let medicines: [String] = [
        "Advil", "Theraflu", "Tylenol", "Zyrtec", "Ibuprofen",
        "Pepto Bismol", "Claritin", "Tums", "Aspirin", "Amoxicillin", "Acetaminophen"
    ]

    @AppStorage("loggedMedicines") private var storedMedicineString: String = ""
    @AppStorage("rewardPoints") private var rewardPoints: Int = 0

    @Environment(\.dismiss) var dismiss

    @State private var selectedMed = ""
    @State private var showExpirationSheet = false
    @State private var showReminderSheet = false
    @State private var selectedDate = Date()

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 16)], spacing: 20) {
                ForEach(medicines, id: \.self) { med in
                    VStack(spacing: 10) {
                        AsyncImage(url: URL(string: imageURL(for: med))) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 100)
                        .cornerRadius(8)

                        Text(med)
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        if let desc = medicineDescriptions[med] {
                            Text(desc)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Button("Log") {
                            selectedMed = med
                            showExpirationSheet = true
                        }
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Log New Medicine")
        .sheet(isPresented: $showExpirationSheet) {
            ExpirationEntryView(
                medicineName: selectedMed,
                onSaved: {
                    logMedicine(selectedMed)
                    showExpirationSheet = false
                    showReminderSheet = true
                },
                selectedDate: $selectedDate
            )
        }
        .sheet(isPresented: $showReminderSheet) {
            ReminderPickerView(selectedDate: $selectedDate)
        }
    }

    private func logMedicine(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        let current = storedMedicineString
            .split(separator: "|")
            .map { String($0) }

        if !current.contains(trimmed) {
            storedMedicineString = (current + [trimmed]).joined(separator: "|")
            rewardPoints += 50
        }
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

    private var medicineDescriptions: [String: String] {
        [
            "Advil": "Pain reliever, fever reducer, and anti-inflammatory",
            "Theraflu": "Cold & flu relief medication",
            "Tylenol": "Pain reliever and fever reducer",
            "Zyrtec": "24-hour allergy relief antihistamine",
            "Ibuprofen": "Non-steroidal anti-inflammatory drug (NSAID)",
            "Pepto Bismol": "Relief for upset stomach, heartburn, and diarrhea",
            "Claritin": "Non-drowsy 24-hour allergy relief",
            "Tums": "Antacid for heartburn and acid indigestion relief",
            "Aspirin": "Pain reliever and fever reducer",
            "Acetaminophen": "Pain reliever and fever reducer",
            "Amoxicillin": "Antibiotic used to treat bacterial infections"
        ]
    }
}
