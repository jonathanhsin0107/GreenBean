//
//  ScanReceipt.swift
//  GreenBean
//
//  Created by Jonathan on 2/27/25.
//  used code by Osman Balci
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import SwiftUI
import Vision

struct ScanReceipt: View {
    @Binding var selectedTab: Int
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var foundProductsList = [FoundProductStruct]()
    @State private var validDollars : Double = 0.0
    
    @EnvironmentObject var rewardsAlgo: RewardsAlgorithm
    
    var body: some View {
        Form {
            Section(header: Text("Take a Photo")) {
                Button("Scan Receipt") {
                    showImagePicker = true
                }
            }

            Section(header: Text("Recognized Products")) {
                if foundProductsList.isEmpty {
                    Text("No products found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(foundProductsList.indices, id: \.self) { index in
                        let product = foundProductsList[index]

                        HStack {
                            Text(product.name)
                            Spacer()
                            Text(String(format: "$%.2f", product.price))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            if !foundProductsList.isEmpty{
                Section(header: Text("Sustainable Shopping Amount Spent")){
                    Text(String(format: "$%.2f", validDollars))
                }
                Section(header: Text("Earn Points")){
                    Button(action: {selectedTab=3
                        rewardsAlgo.computePoints(spent: validDollars, event: nil)
                        foundProductsList = [FoundProductStruct]()
                    }) {
                        Text("Add Points")
                            .padding()
                        //  .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $pickedUIImage, sourceType: .camera, imageWidth: 500.0, imageHeight: 281.25)
        }
        .onChange(of: pickedUIImage) { _, newValue in
            if let image = newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    recognizeText(from: image)
                }
            }
        }
    }
    private func recognizeText(from image: UIImage) {
        foundProductsList = [FoundProductStruct]()
        validDollars = 0.0
        if let image = pickedUIImage,
           let imageData = image.jpegData(compressionQuality: 0.9) {
            
            let base64String = imageData.base64EncodedString()
            
            let postData: [String: Any] = [
                "file_name": "receipt.jpg",          // Required by Veryfi
                "file_data": base64String,           // The Base64 encoded JPEG data
                // Add other optional fields here if needed, like tags or boost_mode
            ]
            
            if let responseData = postJsonDataToApi(
                apiHeaders: veryfiHeaders,
                apiUrl: veryfiEndpoint,
                postData: postData,
                timeout: 30.0
            ) {
                // Handle response data here
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: responseData,
                                                                        options: JSONSerialization.ReadingOptions.mutableContainers)
                    //----------------------------
                    // Obtain Top Level Dictionary
                    //----------------------------
                    var topLevelDictionary = [String: Any]()
                    
                    if let jsonObject = jsonResponse as? [String: Any] {
                        topLevelDictionary = jsonObject
                    } else {
                        return
                    }
                    
                    //---------------------------------------
                    // Obtain Array of "results" JSON Objects
                    //---------------------------------------
                    var arrayOfResultsJsonObjects = [Any]()
                    
                    if let jsonArray = topLevelDictionary["line_items"] as? [Any] {
                        arrayOfResultsJsonObjects = jsonArray
                    } else {
                        return
                    }
                    var tempProductsList: [FoundProductStruct] = []
                    var tempValidDollars: Double = 0.0
                    
                    for foundProductObj in arrayOfResultsJsonObjects {
                        //--------------------------
                        // Obtain Product Dictionary
                        //--------------------------
                        var foundProductDictionary = [String: Any]()
                        
                        if let jsonDictionary = foundProductObj as? [String: Any] {
                            foundProductDictionary = jsonDictionary
                        } else {
                            return
                        }
                        
                        //-----------------------
                        // Obtain Product Name
                        //-----------------------
                        //var currname = ""
                        guard let currname = foundProductDictionary["description"] as? String
                        else{
                            continue
                        }
                        
                        //----------------------
                        // Obtain Product Price
                        //----------------------
                        //var currprice = 0.0
                        
                        guard let currprice = foundProductDictionary["total"] as? Double
                        else{
                            continue
                        }
                        
                        let currProduct=FoundProductStruct(name: currname, price: currprice)
                        tempProductsList.append(currProduct)
                        switch currProduct.name{
                            case "NPR CF EX LR BRN EGG" : tempValidDollars += currProduct.price
                            case "EB ORG LRG BROWN EGG" : tempValidDollars += currProduct.price
                            default : tempValidDollars += 0.0
                        }
                    }   //End of for loop
                    self.foundProductsList = tempProductsList
                    self.validDollars = tempValidDollars
                    
                } catch {
                    print("Error parsing CarbonSutra API JSON: \(error.localizedDescription)")
                }
            }
        }
    }
}
