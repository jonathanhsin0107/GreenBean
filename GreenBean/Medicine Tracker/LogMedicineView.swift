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

    var body: some View {
        VStack {
            if loggedList.isEmpty {
                Text("No medicines logged yet.")
                    .foregroundColor(.gray)
                    .italic()
                    .padding()
            } else {
                List {
                    ForEach(loggedList, id: \.self) { med in
                        HStack(alignment: .top, spacing: 12) {
                            // 🌿 New Image Style: Rounded Rectangle with Shadow
                            Image(imageName(for: med))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)

                            // 💊 Medicine Info
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

                            // 🗓️ Expiration Status
                            Text(getExpirationStatus(for: med))
                                .font(.caption2)
                                .foregroundColor(.red)
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
                // Optional: Remove or replace this part if you are no longer using photo-saving!
                if let name = selectedMedicineForPhoto {
                    saveImage(image, for: name)
                }
            }
        }
    }

    // 🌿 Expiration status helper
    private func getExpirationStatus(for name: String) -> String {
        if let timestampString = UserDefaults.standard.string(forKey: "expiration_\(name)"),
           let timestamp = Double(timestampString) {
            let expirationDate = Date(timeIntervalSince1970: timestamp)
            return daysUntilExpiration(from: expirationDate)
        } else {
            return "No date"
        }
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
    }

    // 🎨 Image name matching your Assets.xcassets
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
        default: return "default_medicine_picture" // fallback image
        }
    }

    // 🖼️ Optional: Still here if you're using photos for the "Take Photo" feature
    private func saveImage(_ image: UIImage, for name: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let filename = getDocumentsDirectory().appendingPathComponent("\(name).jpg")
        try? data.write(to: filename)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
