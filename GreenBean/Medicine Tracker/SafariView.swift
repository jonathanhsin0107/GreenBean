//
//  SafariView.swift
//  GreenBean
//
//  Created by Bita Baban on 4/21/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import SwiftUI
import SafariServices

// SafariView - A SwiftUI wrapper for SFSafariViewController
struct SafariView: View {
    let url: URL

    var body: some View {
        SafariViewController(url: url) // A wrapper that uses SafariServices
            .edgesIgnoringSafeArea(.all) // Makes sure SafariView takes up the entire screen
    }
}

// UIViewControllerRepresentable for wrapping SFSafariViewController
struct SafariViewController: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        // Create and return an instance of SFSafariViewController
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // This is where you update the controller if needed.
        // For this use case, you may not need to do anything here.
    }
}

