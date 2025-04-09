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
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var foundProductsList = [FoundProductStruct]()
    
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
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $pickedUIImage, sourceType: .camera, imageWidth: 500.0, imageHeight: 281.25)
        }
        .onChange(of: pickedUIImage) { _, newValue in
            if let image = newValue {
                recognizeText(from: image)
            }
        }
    }
    private func recognizeText(from image: UIImage) {
        foundProductsList = [FoundProductStruct]()
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
                    /*
                     --------------------------------------
                     |   Veryfi API JSON File Structure   |
                     --------------------------------------
                     {
                       .
                       .
                       .
                     ✅"line_items": [
                         {
                           "date": null,
                     ✅"description": "Counter-Eat In",
                           "discount": null,
                           "discount_rate": null,
                           "end_date": null,
                           "full_description": "Counter-Eat In",
                           "hsn": null,
                           "id": 1367679051,
                           "lot": null,
                           "normalized_description": null,
                           "order": 0,
                           "price": null,
                           "quantity": 1,
                           "reference": null,
                           "section": null,
                           "sku": null,
                           "start_date": null,
                           "tags": [],
                           "tax": null,
                           "tax_rate": null,
                           "text": "Counter-Eat In",
                     ✅"total": null,
                           "type": "food",
                           "unit_of_measure": null,
                           "upc": null,
                           "weight": null
                         },
                         {
                           "date": null,
                     ✅"description": "DblDbl",
                           "discount": null,
                           "discount_rate": null,
                           "end_date": null,
                           "full_description": "DblDbl",
                           "hsn": null,
                           "id": 1367679052,
                           "lot": null,
                           "normalized_description": null,
                           "order": 1,
                           "price": null,
                           "quantity": 1,
                           "reference": null,
                           "section": null,
                           "sku": null,
                           "start_date": null,
                           "tags": [],
                           "tax": null,
                           "tax_rate": null,
                           "text": "DblDbl\t\t\t2.65",
                     ✅"total": 2.65,
                           "type": "food",
                           "unit_of_measure": null,
                           "upc": null,
                           "weight": null
                         },
                         {
                           "date": null,
                     ✅"description": "98 Meat Pty XChz",
                           "discount": null,
                           "discount_rate": null,
                           "end_date": null,
                           "full_description": "98 Meat Pty XChz",
                           "hsn": null,
                           "id": 1367679053,
                           "lot": null,
                           "normalized_description": null,
                           "order": 2,
                           "price": null,
                           "quantity": 1,
                           "reference": null,
                           "section": null,
                           "sku": null,
                           "start_date": null,
                           "tags": [],
                           "tax": null,
                           "tax_rate": null,
                           "text": "98 Meat Pty XChz\t\t88.20",
                     ✅"total": 88.2,
                           "type": "food",
                           "unit_of_measure": null,
                           "upc": null,
                           "weight": null
                         }
                       ],
                        .
                        .
                        .
                       }
                     }
                     */
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
                        foundProductsList.append(currProduct)
                    }   //End of for loop
                    
                } catch {
                    print("Error parsing CarbonSutra API JSON: \(error.localizedDescription)")
                }
            }
        }
    }
}
