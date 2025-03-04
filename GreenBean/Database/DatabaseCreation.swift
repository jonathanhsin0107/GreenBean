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
        modelContainer = try ModelContainer(for: Restaurant.self, Car.self, Product.self, City.self)
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
    let restaurantFetchDescriptor = FetchDescriptor<Restaurant>()
    var listOfAllRestaurantsInDatabase = [Restaurant]()
    
    do {
        // Obtain all of the Business objects from the database
        listOfAllRestaurantsInDatabase = try modelContext.fetch(restaurantFetchDescriptor)
    } catch {
        fatalError("Unable to fetch Restaurant objects from the database")
    }
    
    if !listOfAllRestaurantsInDatabase.isEmpty {
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
    var restaurantStructList = [RestaurantStruct]()
    restaurantStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "RestaurantInitialContent.json", fileLocation: "Main Bundle")

    for aRestaurant in restaurantStructList {
        // Example userImageName = "2A9B8E84-429E-44DC-A6BA-4793558D1180.jpg"
        let filenameComponents = aRestaurant.userImageName.components(separatedBy: ".")
        
        // filenameComponents[0] = "2A9B8E84-429E-44DC-A6BA-4793558D1180"
        // filenameComponents[1] = "jpg"
        
        // Copy the photo file from Assets.xcassets to document directory.
        // The function is given in UtilityFunctions.swift
        copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents[0], fileExtension: filenameComponents[1])
        
        // Example audioNoteFilename = "BDB2D176-D39C-4F22-976E-F525F15C0936.m4a"
        let filenameComponents2 = aRestaurant.audioNoteFilename.components(separatedBy: ".")
        
        // filenameComponents[0] = "BDB2D176-D39C-4F22-976E-F525F15C0936"
        // filenameComponents[1] = "m4a"
        
        // Copy the audio file from project folder (main bundle) to document directory
        // The function is given in UtilityFunctions.swift
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents2[0], fileExtension: filenameComponents2[1])
        
        // Example userVideoName = "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4"
        let filenameComponents3 = aRestaurant.userVideoName.components(separatedBy: ".")
        
        // filenameComponents[0] = "ED286A58-689E-4B65-90B7-BF7EE65E0CD1"
        // filenameComponents[1] = "mp4"
        
        // Copy the audio file from project folder (main bundle) to document directory
        // The function is given in UtilityFunctions.swift
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents3[0], fileExtension: filenameComponents3[1])
        
        // Instantiate a new Business object and dress it up
        let newRestaurant = Restaurant(
            name: aRestaurant.name,
            imageUrl: aRestaurant.imageUrl,
            rating: aRestaurant.rating,
            reviewCount: aRestaurant.reviewCount,
            phone: aRestaurant.phone,
            websiteUrl: aRestaurant.websiteUrl,
            address1: aRestaurant.address1,
            address2: aRestaurant.address2,
            address3: aRestaurant.address3,
            city: aRestaurant.city,
            state: aRestaurant.state,
            zipCode: aRestaurant.zipCode,
            country: aRestaurant.country,
            latitude: aRestaurant.latitude,
            longitude: aRestaurant.longitude,
            isReview: aRestaurant.isReview,
            userRating: aRestaurant.userRating,
            textReview: aRestaurant.textReview,
            userImageName: aRestaurant.userImageName,
            userVideoName: aRestaurant.userVideoName,
            audioNoteFilename: aRestaurant.audioNoteFilename,
            speechToText: aRestaurant.speechToText)
        
        // Insert the new Business object into the database
        modelContext.insert(newRestaurant)
        
    }   // End of the for loop

    
    /*
     ***********************************************************
     *   Create and Populate the Restaurants in the Database   *
     ***********************************************************
     */
    var productStructList = [ProductStruct]()
    productStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "ProductInitialContent.json", fileLocation: "Main Bundle")
    
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
            name: aProduct.name,
            price: aProduct.price,
            product_notes: aProduct.product_notes,
            photoFilename: aProduct.photoFilename,
            productWebsite: aProduct.productWebsite,
            isReview: aProduct.isReview,
            userRating: aProduct.userRating,
            textReview: aProduct.textReview,
            userImageName: aProduct.userImageName,
            userVideoName: aProduct.userVideoName,
            audioNoteFilename: aProduct.audioNoteFilename,
            speechToText: aProduct.speechToText)
        
        // Insert the new Business object into the database
        modelContext.insert(newProduct)
        
    }   // End of the for loop
    
    /*
    ***********************************************************
    *   Create and Populate the Cars in the Database          *
    ***********************************************************
    */
    var carStructList = [CarStruct]()
    carStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "CarInitialContent.json", fileLocation: "Main Bundle")
    
    for aCar in carStructList {
        // Example userImageName = "2A9B8E84-429E-44DC-A6BA-4793558D1180.jpg"
        let filenameComponents = aCar.userImageName.components(separatedBy: ".")
        
        // Copy the photo file from Assets.xcassets to the document directory
        copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents[0], fileExtension: filenameComponents[1])
        
        // Example audioNoteFilename = "BDB2D176-D39C-4F22-976E-F525F15C0936.m4a"
        let filenameComponents2 = aCar.audioNoteFilename.components(separatedBy: ".")
        
        // Copy the audio file from project folder (main bundle) to document directory
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents2[0], fileExtension: filenameComponents2[1])
        
        // Example userVideoName = "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4"
        let filenameComponents3 = aCar.userVideoName.components(separatedBy: ".")
        
        // Copy the video file from project folder (main bundle) to document directory
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents3[0], fileExtension: filenameComponents3[1])
        
        // Instantiate a new Car object and populate it
        let newCar = Car(
            make: aCar.make,
            model: aCar.model,
            imageUrl: aCar.imageUrl,
            city_mpg: aCar.city_mpg,
            combination_mpg: aCar.combination_mpg,
            cylinders: aCar.cylinders,
            drive: aCar.drive,
            fuel_type: aCar.fuel_type,
            transmission: aCar.transmission,
            year: aCar.year,
            co2_lb: aCar.co2_lb,
            isReview: aCar.isReview,
            userRating: aCar.userRating,
            textReview: aCar.textReview,
            userImageName: aCar.userImageName,
            userVideoName: aCar.userVideoName,
            audioNoteFilename: aCar.audioNoteFilename,
            speechToText: aCar.speechToText)
        
        // Insert the new Car object into the database
        modelContext.insert(newCar)
    }   // End of the for loop
    
    /*
     ***********************************************************
     *   Create and Populate the Cities in the Database        *
     ***********************************************************
     */
    var cityStructList = [CityStruct]()
    cityStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "CityInitialContent.json", fileLocation: "Main Bundle")

    for aCity in cityStructList {
        // Example userImageName = "2A9B8E84-429E-44DC-A6BA-4793558D1180.jpg"
        let filenameComponents = aCity.userImageName.components(separatedBy: ".")
        
        // Copy the photo file from Assets.xcassets to the document directory
        copyImageFileFromAssetsToDocumentDirectory(filename: filenameComponents[0], fileExtension: filenameComponents[1])
        
        // Example audioNoteFilename = "BDB2D176-D39C-4F22-976E-F525F15C0936.m4a"
        let filenameComponents2 = aCity.audioNoteFilename.components(separatedBy: ".")
        
        // Copy the audio file from project folder (main bundle) to document directory
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents2[0], fileExtension: filenameComponents2[1])
        
        // Example userVideoName = "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4"
        let filenameComponents3 = aCity.userVideoName.components(separatedBy: ".")
        
        // Copy the video file from project folder (main bundle) to document directory
        copyFileFromMainBundleToDocumentDirectory(filename: filenameComponents3[0], fileExtension: filenameComponents3[1])
        
        // Instantiate a new City object and populate it
        let newCity = City(
            name: aCity.name,
            imageUrl: aCity.imageUrl,
            country: aCity.country,
            countryCode: aCity.countryCode,
            region: aCity.region,
            regionCode: aCity.regionCode,
            elevationMeters: aCity.elevationMeters,
            population: aCity.population,
            timeone: aCity.timeone,
            latitude: aCity.latitude,
            longitude: aCity.longitude,
            isReview: aCity.isReview,
            userRating: aCity.userRating,
            textReview: aCity.textReview,
            userImageName: aCity.userImageName,
            userVideoName: aCity.userVideoName,
            audioNoteFilename: aCity.audioNoteFilename,
            speechToText: aCity.speechToText)
        
        // Insert the new City object into the database
        modelContext.insert(newCity)
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
