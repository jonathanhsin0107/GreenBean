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
    
    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
            // Change the color mode of the entire app to Dark or Light
            .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}
