//
//  DatabaseClasses.swift
//  Businesses
//
//  Created by Osman Balci on 10/20/24.
//  Modified by Jonathan on 11/8/24.
//  Copyright © 2024 Jonathan Hsin. All rights reserved.
//

import SwiftUI
import SwiftData

@Model final class Restaurant{
    var name: String
    var imageUrl: String
    var rating: Double
    var reviewCount: Int
    var phone: String
    var websiteUrl: String
    var address1: String
    var address2: String
    var address3: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var latitude: Double
    var longitude: Double
    var isReview: Bool
    
    //Review list exclusive variables
    var userRating: Double
    var textReview: String
    var userImageName: String   // Photo full filename = filename + fileExtension .jpg
    var userVideoName: String   // Video full filename = filename + fileExtension .mp4
    var audioNoteFilename: String   // Recorded voice full filename = filename + fileExtension (.m4a)
    var speechToText: String
    
    init(name: String, imageUrl: String, rating: Double, reviewCount: Int, phone: String, websiteUrl: String, address1: String, address2: String, address3: String, city: String, state: String, zipCode: String, country: String, latitude: Double, longitude: Double, isReview: Bool, userRating: Double, textReview: String, userImageName: String, userVideoName: String, audioNoteFilename: String, speechToText: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.rating = rating
        self.reviewCount = reviewCount
        self.phone = phone
        self.websiteUrl = websiteUrl
        self.address1 = address1
        self.address2 = address2
        self.address3 = address3
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.isReview = isReview
        self.userRating = userRating
        self.textReview = textReview
        self.userImageName = userImageName
        self.userVideoName = userVideoName
        self.audioNoteFilename = audioNoteFilename
        self.speechToText = speechToText
    }
}

@Model final class City{
    var name: String
    var imageUrl: String
    var country: String
    var countryCode: String
    var region: String
    var regionCode: String
    var elevationMeters: Double
    var population: Int
    var timeone: String
    var latitude: Double
    var longitude: Double
    var isReview: Bool
    
    //Review list exclusive variables
    var userRating: Double
    var textReview: String
    var userImageName: String   // Photo full filename = filename + fileExtension .jpg
    var userVideoName: String   // Video full filename = filename + fileExtension .mp4
    var audioNoteFilename: String   // Recorded voice full filename = filename + fileExtension (.m4a)
    var speechToText: String
    
    init(name: String, imageUrl: String, country: String, countryCode: String, region: String, regionCode: String, elevationMeters: Double, population: Int, timeone: String, latitude: Double, longitude: Double, isReview: Bool, userRating: Double, textReview: String, userImageName: String, userVideoName: String, audioNoteFilename: String, speechToText: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.country = country
        self.countryCode = countryCode
        self.region = region
        self.regionCode = regionCode
        self.elevationMeters = elevationMeters
        self.population = population
        self.timeone = timeone
        self.latitude = latitude
        self.longitude = longitude
        self.isReview = isReview
        self.userRating = userRating
        self.textReview = textReview
        self.userImageName = userImageName
        self.userVideoName = userVideoName
        self.audioNoteFilename = audioNoteFilename
        self.speechToText = speechToText
    }
}

@Model final class Car{
    var make: String
    var model: String
    var imageUrl: String
    var city_mpg: Int
    var combination_mpg: Int
    var cylinders: Int
    var drive: String
    var fuel_type: String
    var transmission: String
    var year: Int
    var co2_lb: Double
    var isReview: Bool
    
    //Review list exclusive variables
    var userRating: Double
    var textReview: String
    var userImageName: String   // Photo full filename = filename + fileExtension .jpg
    var userVideoName: String   // Video full filename = filename + fileExtension .mp4
    var audioNoteFilename: String   // Recorded voice full filename = filename + fileExtension (.m4a)
    var speechToText: String
    
    init(make: String, model: String, imageUrl: String, city_mpg: Int, combination_mpg: Int, cylinders: Int, drive: String, fuel_type: String, transmission: String, year: Int, co2_lb: Double, isReview: Bool, userRating: Double, textReview: String, userImageName: String, userVideoName: String, audioNoteFilename: String, speechToText: String) {
        self.make = make
        self.model = model
        self.imageUrl = imageUrl
        self.city_mpg = city_mpg
        self.combination_mpg = combination_mpg
        self.cylinders = cylinders
        self.drive = drive
        self.fuel_type = fuel_type
        self.transmission = transmission
        self.year = year
        self.co2_lb = co2_lb
        self.isReview = isReview
        self.userRating = userRating
        self.textReview = textReview
        self.userImageName = userImageName
        self.userVideoName = userVideoName
        self.audioNoteFilename = audioNoteFilename
        self.speechToText = speechToText
    }
}

@Model final class Product{
    var name: String
    var price: Double
    var product_notes: String
    var photoFilename: String    // Photo full filename = filename + fileExtension .jpg
    var productWebsite: String
    var isReview: Bool
    
    
    //Review list exclusive variables
    var userRating: Double
    var textReview: String
    var userImageName: String   // Photo full filename = filename + fileExtension .jpg
    var userVideoName: String   // Video full filename = filename + fileExtension .mp4
    var audioNoteFilename: String   // Recorded voice full filename = filename + fileExtension (.m4a)
    var speechToText: String
    
    init(name: String, price: Double, product_notes: String, photoFilename: String, productWebsite: String, isReview: Bool, userRating: Double, textReview: String, userImageName: String, userVideoName: String, audioNoteFilename: String, speechToText: String) {
        self.name = name
        self.price = price
        self.product_notes = product_notes
        self.photoFilename = photoFilename
        self.productWebsite = productWebsite
        self.isReview = isReview
        self.userRating = userRating
        self.textReview = textReview
        self.userImageName = userImageName
        self.userVideoName = userVideoName
        self.audioNoteFilename = audioNoteFilename
        self.speechToText = speechToText
    }
}
