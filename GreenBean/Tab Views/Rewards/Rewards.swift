// Program that creates the UI/preview of the rewards page. 
// Also integrates the reward points algorithm to ensure that reward points
// are calculated accurately.

// CS 4644 (Creative Computing Capstone)
// Team 1 (GreenBean)

import SwiftUI

struct Rewards: View {
    @StateObject private var rewardsAlgo = RewardsAlgorithm()

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
            //.padding(.horizontal)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                //  .frame(height: 100)
            
                HStack {    
                    if let badge = rewardsAlgo.currentBadge, let badgeImage = getBadgeImage(for: badge) {
                        Image(badgeImage)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text("Badge 🏅: \(badge)")
                            .font(.title3)
                            .foregroundColor(.green)
                            .bold()
                    } else {
                        Text("No badges earned yet!")
                            .font(.title2)
                    }
                }
                .padding()
            }
            .padding(.horizontal)

            ZStack {
                NavigationLink(destination: Scan()) {
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
            case "Sustainability Champion": return "sustainability_champion_picture"
            default: return nil
        }
    }
}
            
#Preview {
  Rewards()
}
