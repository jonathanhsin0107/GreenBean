//
//  GreenBeanApp.swift
//  GreenBean
//
//  Created by Jonathan on 2/25/25.
//

import SwiftUI
import SwiftData

@main
struct GreenBeanApp: App {
    init() {
        createDatabase()
    }

    @AppStorage("darkMode") private var darkMode = false

    // Fun fact alert state
    @State private var showFunFactAlert = false
    @State private var chosenFunFact    = ""
    @State private var hasShownFunFact  = false

    private let allFunFacts: [String] = [
        "Recycling one aluminum can saves enough energy to run a TV for 3 hours!",
        "A single tree can absorb up to 48 pounds of CO₂ per year!",
        "Switch to LED bulbs to save energy and reduce your electricity bill.",
        "Use reusable shopping bags to help reduce plastic waste!",
        "Consider biking or walking instead of driving to reduce your carbon footprint.",
        "Composting helps reduce food waste and enriches your soil.",
        "A hot water faucet that leaks one drop per second can waste 165 gallons a month.",
        "An energy‐smart washer can save more water in one year than one person drinks in a lifetime.",
        "Americans consume 26% of the world's energy but make up only 5% of the population.",
        "A CFL bulb uses 75% less energy than an incandescent and can last up to four years.",
        "Recycling one ton of paper saves 7,000 gallons of water and three cubic yards of landfill space.",
        "Over 40% of U.S. municipal waste is paper—about 71.8 tons per year."
    ]

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkMode ? .dark : .light)
                .modelContainer(for: [Product.self], isUndoEnabled: true)

                // Only trigger once when ContentView appears
                .task {
                    if !hasShownFunFact {
                        chosenFunFact = allFunFacts.randomElement() ?? ""
                        showFunFactAlert = true
                        hasShownFunFact = true
                    }
                }

                .alert("🌍 Fun Fact", isPresented: $showFunFactAlert) {
                    Button("Got it!", role: .cancel) {}
                } message: {
                    Text(chosenFunFact)
                }
        }
    }
}
