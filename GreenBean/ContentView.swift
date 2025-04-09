//
//  ContentView.swift
//  GreenBean
//
//  Created by Jonathan on 9/26/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
        @Environment(\.modelContext) private var modelContext
        @State private var selectedTab: Int = 0
        @StateObject private var rewardsAlgo = RewardsAlgorithm()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Rewards(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "medal.fill")
                    Text("Rewards")
                }
                .tag(3)

            Search()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(2)
                
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            Favorites()
                .tabItem {
                    Image(systemName:"heart.fill")
                    Text("Favorites")
                }
                .tag(4)
                
            Scan()
                .tabItem {
                    Image(systemName: "document.viewfinder")
                    Text("Scan")
                }
                .tag(1)

            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
        }   // End of TabView
        .environmentObject(rewardsAlgo) // makes the rewardPointsAlgorithm available to all views
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
