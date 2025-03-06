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
        modelContainer = try ModelContainer(for: Product.self)
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
    let productsFetchDescriptor = FetchDescriptor<Product>()
    var listOfAllProductsInDatabase = [Product]()
    
    do {
        // Obtain all of the Business objects from the database
        listOfAllProductsInDatabase = try modelContext.fetch(productsFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Store objects from the database")
    }
    
    if !listOfAllProductsInDatabase.isEmpty {
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
    productStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "InitialContent.json", fileLocation: "Main Bundle")
    
    for aProduct in productStructList {
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
