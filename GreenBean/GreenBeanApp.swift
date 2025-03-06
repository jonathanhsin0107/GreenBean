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
    init(){
        // Create Products Database upon App Launch IF the app is being launched for the first time.
        createDatabase()      // Given in DatabaseCreation.swift
        
    }
    
    @Environment(\.undoManager) var undoManager
    @AppStorage("darkMode") private var darkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
            // Change the color mode of the entire app to Dark or Light
            .preferredColorScheme(darkMode ? .dark : .light)
            
            /*
             Inject the Model Container into the environment so that you can access its Model Context
             in a SwiftUI file by using @Environment(\.modelContext) private var modelContext
             */
            .modelContainer(for: [Product.self], isUndoEnabled: true)
        }
    }
}
