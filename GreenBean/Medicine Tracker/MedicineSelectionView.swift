import SwiftUI

struct MedicineSelectionView: View {
    // MARK: - State & Storage
    @State private var selectedMed: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showExpirationSheet = false
    @State private var showReminderSheet = false

    @AppStorage("loggedMedicines") private var storedMedicineString: String = ""
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm

    // Full catalog of medicines
    struct Medicine: Identifiable {
        let id = UUID()
        let name: String
        let imageUrl: String
        let info: String
    }

    let medicines: [Medicine] = [
        Medicine(
            name: "Advil",
            imageUrl: "https://m.media-amazon.com/images/I/81-JFc-sotL._AC_UF1000,1000_QL80_.jpg",
            info: "Pain reliever, fever reducer, and anti‑inflammatory"
        ),
        Medicine(
            name: "Theraflu",
            imageUrl: "https://cdn.discount-drugmart.com/products/images/syndigo/e730a004-f954-4b6f-86cf-13f03864ddf2/600/20b4253e-90c4-4533-a6eb-155c58c99380.jpg",
            info: "Cold & flu relief medication"
        ),
        Medicine(
            name: "Tylenol",
            imageUrl: "https://cdn.drugstore2door.com/catalog/product/cache/4c0d23783922484128e316257934ccaf/0/0/00300450449092_1_2.jpg",
            info: "Pain reliever and fever reducer"
        ),
        Medicine(
            name: "Zyrtec",
            imageUrl: "https://cdn.discount-drugmart.com/products/images/syndigo/e730a004-f954-4b6f-86cf-13f03864ddf2/600/3fbe12ba-1d21-4deb-8930-0e61359f2c93.jpg",
            info: "24‑hour allergy relief antihistamine"
        ),
        Medicine(
            name: "Ibuprofen",
            imageUrl: "https://www.associatedbag.com/images/catalog/web266-9-08_400.jpg",
            info: "Non‑steroidal anti‑inflammatory drug (NSAID)"
        ),
        Medicine(
            name: "Pepto Bismol",
            imageUrl: "https://m.media-amazon.com/images/I/71nSMz337iL._AC_UF894,1000_QL80_.jpg",
            info: "Relief for upset stomach, heartburn, and diarrhea"
        ),
        Medicine(
            name: "Claritin",
            imageUrl: "https://i5.walmartimages.com/seo/Claritin-24-Hour-Non-Drowsy-Allergy-Medicine-Loratadine-Antihistamine-Tablets-10-Ct_32a6a546-8004-437a-afb2-2294a84f2f8f.f6a05a30e8f5835cd15fd2b00e4771af.jpeg",
            info: "Non‑drowsy 24‑hour allergy relief"
        ),
        Medicine(
            name: "Tums",
            imageUrl: "https://cdn.discount-drugmart.com/products/images/syndigo/e730a004-f954-4b6f-86cf-13f03864ddf2/600/167a9533-407e-4a32-90de-f499bfafcad6.jpg",
            info: "Antacid for heartburn and acid indigestion relief"
        ),
        Medicine(
            name: "Aspirin",
            imageUrl: "https://www.aspirin.ca/sites/g/files/vrxlpx30151/files/2021-06/Aspirin-Regular-extra-strength-100ct-carton.png",
            info: "Pain reliever and fever reducer"
        ),
        Medicine(
            name: "Amoxicillin",
            imageUrl: "https://www.poison.org/-/media/images/shared/articles/amoxicillin.jpg",
            info: "Antibiotic used to treat bacterial infections"
        ),
        Medicine(
            name: "Acetaminophen",
            imageUrl: "https://athome.medline.com/media/catalog/product/cache/629a5912a555bf7b815eea5423d5ef47/o/t/otc802401_01_1.jpg",
            info: "Pain reliever and fever reducer"
        )
    ]

    // Two‑column grid layout
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(medicines) { med in
                    VStack(spacing: 12) {
                        // Thumbnail with uniform size and proper image handling
                        AsyncImage(url: URL(string: med.imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ZStack {
                                    Color.gray.opacity(0.2)
                                    ProgressView()
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                // Show default system image if remote load fails
                                Image(systemName: "pills.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(20)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 160, height: 100)
                        .clipped()
                        .cornerRadius(12)

                        // Name & description
                        Text(med.name)
                            .font(.headline)
                            .multilineTextAlignment(.center)

                        Text(med.info)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .frame(height: 40)
                            .padding(.horizontal, 4)

                        // Log button
                        Button(action: {
                            selectedMed = med.name
                            showExpirationSheet = true
                        }) {
                            Text("Log")
                                .font(.body)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                        .background(Color.green.opacity(0.3))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
            .padding(.horizontal)
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
            ReminderPickerView(name: selectedMed, selectedDate: $selectedDate)
                .environmentObject(rewardsAlgo)
        }
    }

    // MARK: - Helper
    private func logMedicine(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        var current = storedMedicineString.split(separator: "|").map(String.init)
        guard !current.contains(trimmed) else { return }
        current.append(trimmed)
        storedMedicineString = current.joined(separator: "|")
        rewardsAlgo.addPoints(50)
    }
}
