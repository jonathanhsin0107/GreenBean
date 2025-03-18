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
                Text("Total Points: \(rewardsAlgo.totalPoints)")
                    .font(.title2)
                    .padding()
            }

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                
                if let badge = rewardsAlgo.currentBadge {
                    Text("Badge 🏅: \(badge)")
                        .font(.title3)
                        .foregroundColor(.green)
                        .bold()
                } else {
                    Text("No badges earned yet!")
                        .font(.title2)
//                        .foregroundColor(.gray)
                }
            }

            HStack {
                NavigationLink(destination: Scan()) {
                    Text("Scan Purchase to Earn Points")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
            
#Preview {
  Rewards()
}
