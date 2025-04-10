// Program that calculates the reward points for users using the platform (GreenBean).

// CS 4644 (Creative Computing Capstone)
// Team 1 (GreenBean)

import SwiftUI
import Foundation

class RewardsAlgorithm: ObservableObject {
    @Published var totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
    @Published var currentBadge = UserDefaults.standard.string(forKey: "currentBadge")
    @Published var hasReceivedFirstPurchaseBonus = UserDefaults.standard.bool(forKey: "hasReceivedFirstPurchaseBonus")

    
    private let pointsPerDollar = 5
    private let bonusEvents = [
      //"first_purchase": 50,
        "birthday": 100,
        //"referral": 150
    ]
    private let badgeThresholds = [
        (100, "Planet Caretaker"),
        (500, "Ecological Hero"),
        (2000, "Sustainability Champ")
    ]

    func computePoints(spent: Double, event: String?) {
        let basePoints = Int(spent) * pointsPerDollar
        var bonus = 0

        if !hasReceivedFirstPurchaseBonus {
            bonus += 50
            hasReceivedFirstPurchaseBonus = true
            UserDefaults.standard.set(true, forKey: "hasReceivedFirstPurchaseBonus")
        }
        bonus += bonusEvents[event ?? ""] ?? 0
        totalPoints += basePoints + bonus
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
        hasReceivedFirstPurchaseBonus = false
        
        saveData()
        UserDefaults.standard.set(false, forKey: "hasReceivedFirstPurchaseBonus")
    }
  
    private func saveData() {
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
        UserDefaults.standard.set(currentBadge, forKey: "currentBadge")
    }    
}
