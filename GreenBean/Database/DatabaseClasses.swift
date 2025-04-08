//
//  DatabaseClasses.swift
//  GreenBean
//
//  Created by Osman Balci on 10/20/24.
//  Modified by Jonathan on 11/8/24.
//  Copyright © 2024 Jonathan Hsin. All rights reserved.
//

import SwiftUI
import SwiftData

@Model final class Product{
    var productName: String
    var brand: String
    var category: String
    var price: String
    var size: String
    var pricePerUnit: String
    var websiteURL: String
    var location: String
    var store: String
    var imageLink: String
    
    init(productName: String, brand: String, category: String, price: String, size: String, pricePerUnit: String, websiteURL: String, location: String, store: String, imageLink: String) {
        self.productName = productName
        self.brand = brand
        self.category = category
        self.price = price
        self.size = size
        self.pricePerUnit = pricePerUnit
        self.websiteURL = websiteURL
        self.location = location
        self.store = store
        self.imageLink = imageLink
    }
}
@Model final class FoundProduct{
    var name: String
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
}
