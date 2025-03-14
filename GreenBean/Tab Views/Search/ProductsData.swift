//
//  ProductsData.swift
//  GreenBean
//
//  Created by Joseph Tran on 3/9/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

// ProductsData.swift
import Foundation

struct ProductsData: Identifiable {
    var id = UUID()
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

let productStructList = [
    ProductsData(
        productName: "Eggland's Best Organic Cage Free Large Brown Eggs",
        brand: "Eggland's Best",
        category: "Dairy & Eggs",
        price: "7.99",
        size: "1 DOZ",
        pricePerUnit: "$7.99 /DOZ",
        websiteURL: "https://foodlion.com/product/egglands-best-organic-cage-free-large-brown-eggs-1-doz/149104",
        location: "801 Hethwood Blvd\nBlacksburg, VA 24060",
        store: "Food Lion",
        imageLink: "https://assets.syndigo.cloud/cdn/81b2012d-02e1-4274-96af-cb31cf94eada/fileType_jpg;size_600x600/81b2012d-02e1-4274-96af-cb31cf94eada"
    ),
    ProductsData(
        productName: "Nature's Promise Organic Cage Free Large Brown Eggs",
        brand: "Nature's Promise",
        category: "Dairy & Eggs",
        price: "6.99",
        size: "1 DOZ",
        pricePerUnit: "$6.99 /DOZ",
        websiteURL: "https://foodlion.com/product/natures-promise-organic-cage-free-large-brown-eggs-1-doz/295902",
        location: "North main1413 N. Main Street\nBlacksburg, VA 24060",
        store: "Food Lion",
        imageLink: "https://res.cloudinary.com/syndigo/image/fetch/f_jpg/https://assets.edgenet.com/5b8a2089-1c4f-4939-b87b-0495904abb83%3Fsize=600x600"
    ),
    ProductsData(
        productName: "Nature's Promise Organic Cage Free Large Brown Eggs",
        brand: "Nature's Promise",
        category: "Dairy & Eggs",
        price: "6.99",
        size: "2 DOZ",
        pricePerUnit: "$6.99 /DOZ",
        websiteURL: "https://foodlion.com/product/natures-promise-organic-cage-free-large-brown-eggs-1-doz/295903",
        location: "801 Hethwood Blvd",
        store: "Food Lion",
        imageLink: "https://assets.syndigo.cloud/cdn/3e501237-41fe-4499-869e-8cd68ae779c6/fileType_jpg;size_600x600/3e501237-41fe-4499-869e-8cd68ae779c6"
    ),
    ProductsData(
        productName: "Eggland's Best 100% USDA Organic Certified Large Brown Eggs",
        brand: "Eggland's Best",
        category: "Dairy & Eggs",
        price: "$5.79",
        size: "1 DOZ",
        pricePerUnit: "$0.48/each",
        websiteURL: "https://www.kroger.com/p/eggland-s-best-100-usda-organic-certified-large-brown-eggs-12-count/0071514171682",
        location: "903 University City Blvd",
        store: "Kroger",
        imageLink: "https://www.kroger.com/product/images/xlarge/front/0071514171682"
    ),
    ProductsData(
        productName: "Happy Egg Co.® Free Range Large Brown Organic Eggs",
        brand: "Happy Egg Co.",
        category: "Dairy & Eggs",
        price: "$7.99",
        size: "2 DOZ",
        pricePerUnit: "$0.67/each",
        websiteURL: "https://www.kroger.com/p/happy-egg-co-free-range-large-brown-organic-eggs/0088742200008",
        location: "903 University City Blvd",
        store: "Kroger",
        imageLink: "https://www.kroger.com/product/images/xlarge/front/0088742200008"
    ),
    ProductsData(
        productName: "Simple Truth Organic™ Cage Free 100% Liquid Egg Whites",
        brand: "Simple Truth Organic",
        category: "Dairy & Eggs",
        price: "$4.29",
        size: "16 oz",
        pricePerUnit: "$0.27/oz",
        websiteURL: "https://www.kroger.com/p/simple-truth-organic-cage-free-100-liquid-egg-whites/0001111004163",
        location: "903 University City Blvd",
        store: "Kroger",
        imageLink: "https://www.kroger.com/product/images/xlarge/front/0001111004163"
    ),
    ProductsData(
        productName: "Simple Truth Organic™ Cage Free Grade A Large Brown Eggs",
        brand: "Simple Truth Organic",
        category: "Dairy & Eggs",
        price: "$5.99",
        size: "1 DOZ",
        pricePerUnit: "$0.50/each",
        websiteURL: "https://www.kroger.com/p/simple-truth-organic-cage-free-grade-a-large-brown-eggs/0001111079772",
        location: "903 University City Blvd",
        store: "Kroger",
        imageLink: "https://www.kroger.com/product/images/xlarge/front/0001111079772"
    ),
    ProductsData(
        productName: "Simple Truth Organic™ Cage Free Large Brown Eggs",
        brand: "Simple Truth Organic",
        category: "Dairy & Eggs",
        price: "$8.49",
        size: "18 ct",
        pricePerUnit: "$0.47/each",
        websiteURL: "https://www.kroger.com/p/simple-truth-organic-cage-free-large-brown-eggs/0001111006479",
        location: "903 University City Blvd",
        store: "Kroger",
        imageLink: "https://www.kroger.com/product/images/xlarge/front/0001111006479"
    )
]
