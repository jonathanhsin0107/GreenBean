// Program that creates the UI/preview of the rewards page. 
// Also integrates the reward points algorithm to ensure that reward points
// are calculated accurately.

// CS 4644 (Creative Computing Capstone)
// Team 1 (GreenBean)

import SwiftUI

struct Rewards: View {
    //@StateObject private var rewardsAlgo = RewardsAlgorithm()
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm    // making rewardsAlgorithm global so scan can use it
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Rewards 🎉")
                .font(.largeTitle)
                .bold()
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                //  .frame(height: 80)
                Text("Total Points: \(rewardsAlgo.totalPoints)")
                    .font(.title2)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                //  .frame(height: 100)
            
                //HStack {
                VStack {
                    if let badge = rewardsAlgo.currentBadge, let badgeImage = getBadgeImage(for: badge) {
                        Image(badgeImage)
                            .resizable()
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 4)
                        
                        Text("Badge🏅: \(badge)")
                            .font(.title3)
                            .foregroundColor(.green)
                            .bold()
                            .multilineTextAlignment(.center)
                    } else {
                        Text("No badges earned yet!")
                            .font(.title2)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            // ----------------------
//            // Just to check if it points and badges are saved and updates correctly
//            VStack(spacing: 10) {
//                Button("Test Purchase ($10)") {
//                    rewardsAlgo.computePoints(spent: 10.0, event: nil)
//                }
//
//                Button("Test Birthday Bonus") {
//                    rewardsAlgo.computePoints(spent: 0.0, event: "birthday")
//                }
//
//                Button("Reset Points & Badge") {
//                    rewardsAlgo.resetRewards()
//                }
//            }
//            .padding()
//            .buttonStyle(.borderedProminent)
//            
//            Spacer()
            // ----------------------
            
            ZStack {
                Button(action: {selectedTab=1}) {
                    Text("Scan Purchase to Earn Points")
                        .padding()
                    //  .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    func getBadgeImage(for badge: String) -> String? {
        switch badge {
            case "Planet Caretaker": return "planet_caretaker_picture"
            case "Ecological Hero": return "ecological_hero_picture"
            case "Sustainability Champ": return "sustainability_champion_picture"
            default: return nil
        }
    }
}
