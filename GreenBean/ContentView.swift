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
            Tab("Rewards", systemImage: "medal.fill") {
                Rewards()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                Search()
            }
            Tab("Scan", systemImage: "document.viewfinder") {
                Scan()
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
