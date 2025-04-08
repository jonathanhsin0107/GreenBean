import SwiftUI
import UIKit

struct LoggedMedicinesView: View {
    @AppStorage("loggedMedicines") private var storedMedicineString: String = ""
    @State private var selectedMedicineForPhoto: String? = nil
    @State private var showCamera = false

    private var loggedList: [String] {
        storedMedicineString
            .split(separator: "|")
            .map { String($0) }
            .filter { !$0.isEmpty }
    }

    private let medicineDescriptions: [String: String] = [
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

    var body: some View {
        VStack {
            if loggedList.isEmpty {
                Text("No medicines logged yet.")
                    .foregroundColor(.gray)
                    .italic()
                    .padding()
            } else {
                List {
                    ForEach(loggedList, id: \..self) { med in
                        HStack(alignment: .top) {
                            if let saved = loadImage(for: med) {
                                Image(uiImage: saved)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            } else {
                                AsyncImage(url: URL(string: imageURL(for: med))) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    } else {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(med)
                                    .font(.headline)

                                if let desc = medicineDescriptions[med] {
                                    Text(desc)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                if let date = expirationDate(for: med) {
                                    let daysLeft = daysUntilExpiration(from: date)
                                    Text(daysLeft)
                                        .font(.caption2)
                                        .foregroundColor(daysLeft.contains("Expired") ? .gray : .red)
                                } else {
                                    Text("No date")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteMedicine(named: med)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                selectedMedicineForPhoto = med
                                showCamera = true
                            } label: {
                                Label("Take Photo", systemImage: "camera")
                            }
                            .tint(.purple)
                        }
                    }
                }
            }
        }
        .navigationTitle("Your Logged Medicines")
        .sheet(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera) { image in
                if let name = selectedMedicineForPhoto {
                    saveImage(image, for: name)
                }
            }
        }
    }

    private func expirationDate(for name: String) -> Date? {
        if let timestampString = UserDefaults.standard.string(forKey: "expiration_\(name)"),
           let timestamp = Double(timestampString) {
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }

    private func daysUntilExpiration(from date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: today, to: target)

        if let days = components.day {
            if days > 0 {
                return "⏳ \(days) day\(days == 1 ? "" : "s") left"
            } else if days == 0 {
                return "⚠️ Expires today"
            } else {
                return "❌ Expired \(-days) day\(days == -1 ? "" : "s") ago"
            }
        }
        return ""
    }

    private func deleteMedicine(named name: String) {
        let current = loggedList.filter { $0 != name }
        storedMedicineString = current.joined(separator: "|")
        UserDefaults.standard.removeObject(forKey: "expiration_\(name)")

        let path = getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        try? FileManager.default.removeItem(at: path)
    }

    private func saveImage(_ image: UIImage, for name: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        let filename = getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        try? data.write(to: filename)
    }

    private func loadImage(for name: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        return UIImage(contentsOfFile: path.path)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
