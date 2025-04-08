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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)

                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            Scan()
                .tabItem {
                    Image(systemName: "document.viewfinder")
                    Text("Scan")
                }
                .tag(1)

            Search()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(2)

            Rewards(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "medal.fill")
                    Text("Rewards")
                }
                .tag(3)

            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}
    
    
#Preview {
    ContentView()
}
