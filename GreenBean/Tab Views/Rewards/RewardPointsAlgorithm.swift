// Program that calculates the reward points for users using the platform (GreenBean).

// CS 4644 (Creative Computing Capstone)
// Team 1 (GreenBean)

import SwiftUI
import Foundation

class RewardsAlgorithm: ObservableObject {
    @Published var totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
    @Published var currentBadge = UserDefaults.standard.string(forKey: "currentBadge")
    
    private let pointsPerDollar = 5
    private let bonusEvents = [
        "first_purchase": 50,
        "birthday": 100,
        "referral": 150
    ]
    private let badgeThresholds = [
        (100, "Planet Caretaker"),
        (500, "Ecological Hero"),
        (2000, "Sustainability Champion")
    ]

    func computePoints(spent: Double, event: String?) {
        let basePoints = Int(spent) * pointsPerDollar
        totalPoints += basePoints + (bonusEvents[event ?? ""] ?? 0)
        updateBadge()
        saveData()
    }
    
    private func updateBadge() {
        for threshold in badgeThresholds {
            if totalPoints >= threshold.0 {
                currentBadge = threshold.1
            }
        }
    }
  
    func resetRewards() {
        totalPoints = 0
        currentBadge = nil
        saveData()
    }
  
    private func saveData() {
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
        UserDefaults.standard.set(currentBadge, forKey: "currentBadge")
    }    
}
