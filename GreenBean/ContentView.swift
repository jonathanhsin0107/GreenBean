//
//  ContentView.swift
//  GreenBean
//
//  Created by Jonathan on 9/26/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                Home()
            }
            Tab("Scan", systemImage: "document.viewfinder") {
                Scan()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                Search()
            }
            Tab("Rewards", systemImage: "medal.fill") {
                Rewards()
            }
            Tab("Settings", systemImage: "gear") {
                Settings()
            }
        }   // End of TabView
        .tabViewStyle(.sidebarAdaptable)
    }
}
    
    
#Preview {
    ContentView()
}
