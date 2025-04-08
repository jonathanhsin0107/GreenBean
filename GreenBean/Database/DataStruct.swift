//
//  DataStruct.swift
//  Businesses
//
//  Created by Jonathan on 11/8/24.
//  Copyright © 2024 Jonathan Hsin. All rights reserved.
//

import SwiftUI

struct StoreStruct: Decodable, Encodable{
    var name: String
    var imageUrl: String
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
}

struct ProductStruct: Decodable, Encodable, Hashable{
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
}

struct FoundProductStruct:Decodable, Encodable, Hashable{
    var name: String
    var price: Double
}
