//
//  Settings.swift
//  GreenBean
//
//  Created by Osman Balci on 9/16/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct Settings: View {
    
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dark Mode Setting")) {
                    Toggle("Dark Mode", isOn: $darkMode)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
