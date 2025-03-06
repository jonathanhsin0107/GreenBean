//
//  DatabaseCreation.swift
//  VibeVault
//
//  Created by Osman Balci on 9/16/24.
//  Modified by Jonathan on 11/29/24.
//

import SwiftUI
import SwiftData

public func createDatabase() {
    /*
     ------------------------------------------------
     |   Create Model Container and Model Context   |
     ------------------------------------------------
     */
    var modelContainer: ModelContainer
    
    do {
        // Create a database container to manage the Businesses
        modelContainer = try ModelContainer(for: Stores.self, Product.self)
    } catch {
        fatalError("Unable to create ModelContainer")
    }
    
    // Create the context where the databse objects will be managed
    let modelContext = ModelContext(modelContainer)
    
    /*
     --------------------------------------------------------------------
     |   Check to see if the database has already been created or not   |
     --------------------------------------------------------------------
     */
    let storesFetchDescriptor = FetchDescriptor<Restaurant>()
    var listOfAllStoresInDatabase = [Restaurant]()
    
    do {
        // Obtain all of the Business objects from the database
        listOfAllStoresInDatabase = try modelContext.fetch(storesFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Store objects from the database")
    }
    
    if !listOfAllStoresInDatabase.isEmpty {
        print("Database has already been created!")
        return
    }
    
    print("Database will be created!")
    
    /*
     ----------------------------------------------------------
     | *** The app is being launched for the first time ***   |
     |   Database needs to be created and populated with      |
     |   the initial content given in the JSON files.         |
     ----------------------------------------------------------
     */
        
    /*
     ***********************************************************
     *   Create and Populate the Restaurants in the Database   *
     ***********************************************************
     */
    var productStructList = [ProductStruct]()
    productStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "InitialContent.json", fileLocation: "Database")
    
    for aProduct in productStructList {
        // Example userImageName = "2A9B8E84-429E-44DC-A6BA-4793558D1180.jpg"
        let filenameComponents = aProduct.userImageName.components(separatedBy: ".")
        
        // filenameComponents[0] = "2A9B8E84-429E-44DC-A6BA-4793558D1180"
        // filenameComponents[1] = "jpg"
        
        // Copy the photo file from Assets.xcassets to document directory.
        // The function is given in UtilityFunctions.swift
        copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents[0], fileExtension: filenameComponents[1])
        
        // Example audioNoteFilename = "BDB2D176-D39C-4F22-976E-F525F15C0936.m4a"
        let filenameComponents2 = aProduct.audioNoteFilename.components(separatedBy: ".")
        
        // filenameComponents[0] = "BDB2D176-D39C-4F22-976E-F525F15C0936"
        // filenameComponents[1] = "m4a"
        
        // Copy the audio file from project folder (main bundle) to document directory
        // The function is given in UtilityFunctions.swift
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents2[0], fileExtension: filenameComponents2[1])
        
        // Example userVideoName = "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4"
        let filenameComponents3 = aProduct.userVideoName.components(separatedBy: ".")
        
        // filenameComponents[0] = "ED286A58-689E-4B65-90B7-BF7EE65E0CD1"
        // filenameComponents[1] = "mp4"
        
        // Copy the audio file from project folder (main bundle) to document directory
        // The function is given in UtilityFunctions.swift
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents3[0], fileExtension: filenameComponents3[1])
        
        // Example photoFilename = "stanley.jpg"
        let filenameComponents4 = aProduct.photoFilename.components(separatedBy: ".")
        
        // filenameComponents[0] = "stanley"
        // filenameComponents[1] = "jpg"
        
        // Copy the photo file from Assets.xcassets to document directory.
        // The function is given in UtilityFunctions.swift
        copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents4[0], fileExtension: filenameComponents4[1])
        // Instantiate a new Business object and dress it up
        let newProduct = Product(
            productName: aProduct.productName,
            brand: aProduct.brand,
            category: aProduct.category,
            price: aProduct.price,
            size: aProduct.size,
            pricePerUnit: aProduct.pricePerUnit,
            websiteURL: aProduct.websiteURL,
            location: aProduct.location,
            store: aProduct.store,
            imageLink: aProduct.imageLink)
        
        // Insert the new Business object into the database
        modelContext.insert(newProduct)
        
    }   // End of the for loop

    /*
     =================================
     |   Save All Database Changes   |
     =================================
     🔴 NOTE: Database changes are automatically saved and SwiftUI Views are
     automatically refreshed upon State change in the UI or after a certain time period.
     But sometimes, you can manually save the database changes just to be sure.
     */
    do {
        try modelContext.save()
    } catch {
        fatalError("Unable to save database changes")
    }
    
    
    print("Database is successfully created!")
}
