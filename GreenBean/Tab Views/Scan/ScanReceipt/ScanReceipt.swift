//
//  ScanReceipt.swift
//  GreenBean
//
//  Created by Jonathan on 2/27/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import SwiftUI
import Vision

struct ScanReceipt: View {
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var rawText: String = ""
    @State private var formattedText: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Take a Photo")) {
                Button("Scan Receipt") {
                    showImagePicker = true
                }
            }
            
            Section(header: Text("Raw Output")) {
                TextField("Raw Text", text: $rawText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Section(header: Text("Formatted Output")) {
                TextField("Formatted Text", text: $formattedText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $pickedUIImage, sourceType: .camera, imageWidth: 500.0, imageHeight: 281.25)
        }
        .onChange(of: pickedUIImage) { oldValue, newValue in
            if let image = pickedUIImage {
                recognizeText(from: image)
            }
        }
    }
    
    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else { return }
            
            let rawOutput = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            let formattedOutput = observations.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: " ")
                .replacingOccurrences(of: "\n", with: " ")
            
            DispatchQueue.main.async {
                rawText = rawOutput
                formattedText = formattedOutput
            }
        }
        request.recognitionLanguages = ["en_US"]
        request.recognitionLevel = .accurate
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
}
