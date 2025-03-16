// Program that creates the UI/preview of the rewards page. 
// Also integrates the reward points algorithm to ensure that reward points
// are calculated accurately.

// CS 4644 (Creative Computing Capstone)
// Team 1 (GreenBean)

import SwiftUI

struct Rewards: View {
    @StateObject private var viewModel = RewardsAlgorithm()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                Text("Your Reward Points: \(viewModel.totalPoints)")
                .font(.title)
            }
            
            if let badge = viewModel.currentBadge {
                Text("Current Badge: \(badge)")
                    .font(.headline)
                    .padding()
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(10)
            }

            Button("Add Points") {
                ScanReceipt()
            }
            .buttonStyle(.borderedProminent)
            
            // Button("Reset Rewards") {
            //     viewModel.resetRewards()
            // }
            // .buttonStyle(.bordered)
            // .foregroundColor(.green)
        }
        // .padding()
    }
}

#Preview {
  Rewards()
}
