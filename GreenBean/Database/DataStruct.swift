//
//  DataStruct.swift
//  Businesses
//
//  Created by Jonathan on 11/8/24.
//  Copyright © 2024 Jonathan Hsin. All rights reserved.
//

import SwiftUI

struct RestaurantStruct: Decodable, Encodable{
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
}
//{
//    "name": "Cellar Restaurant",
//    "imageUrl": "https://s3-media1.fl.yelpcdn.com/bphoto/b_sq8nM-Kum8yV79S_FvCw/o.jpg",
//    "rating": 4.0,
//    "reviewCount": 324,
//    "phone": "(540) 953-0651",
//    "websiteUrl": "https://www.yelp.com/biz/cellar-restaurant-blacksburg?adjust_creative=8dFbh2jfIbhvrq58z45IUQ&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=8dFbh2jfIbhvrq58z45IUQ",
//    "address1": "302 N Main St",
//    "address2": "",
//    "address3": "",
//    "city": "Blacksburg",
//    "state": "VA",
//    "zipCode": "24060",
//    "country": "US",
//    "latitude": 37.23089792536,
//    "longitude": -80.415113333008,
//    "isReview": true,
//
//      "userRating": 4.0,
//      "textReview": "I like this"
//      "userImageName": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.jpg"
//      "userVideoName": "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4",
//      "audioNoteFilename": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.m4a"
//      "speechToText": "I hate this"
//}

struct CityStruct: Decodable, Encodable, Hashable{
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
}
//{
//"name": "New York City",
//"country": "United States of America",
//"countryCode": "US",
//"region": "New York",
//"regionCode": "NY",
//"elevationMeters": 10,
//"latitude": 40.67,
//"longitude": -73.94,
//"population": 8398748,
//"timezone": "America__New_York",
//"isReview": true,
//
//      "userRating": 4.0,
//      "textReview": "I like this"
//      "userImageName": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.jpg"
//      "userVideoName": "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4",
//      "audioNoteFilename": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.m4a"
//      "speechToText": "I hate this"
//}

struct CarStruct: Decodable, Encodable, Hashable{
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
}
//{
//"city_mpg": 18,
//"combination_mpg": 21,
//"cylinders": 4,
//"drive": "fwd",
//"fuel_type": "gas",
//"make": "toyota",
//"model": "camry",
//"transmission": "a",
//"year": 1993,
//"isReview": true,
//
//      "userRating": 4.0,
//      "textReview": "I like this"
//      "userImageName": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.jpg"
//      "userVideoName": "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4",
//      "audioNoteFilename": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.m4a"
//      "speechToText": "I hate this"
// },

struct ProductStruct: Decodable, Encodable{
    var name: String
    var price: Double
    var product_notes: String
    var photoFilename: String    // Photo full filename = filename + fileExtension .jpg
    var isReview: Bool
    var productWebsite: String
    
    
    //Review list exclusive variables
    var userRating: Double
    var textReview: String
    var userImageName: String   // Photo full filename = filename + fileExtension .jpg
    var userVideoName: String   // Video full filename = filename + fileExtension .mp4
    var audioNoteFilename: String   // Recorded voice full filename = filename + fileExtension (.m4a)
    var speechToText: String
}
//{
//    "name": "Apple iPhone 11",
//    "price": 699,
//    "product_notes": "Despite minimal exterior changes from the preceding iPhone XR, substantial design changes within the phone took place, including the addition of the more powerful Apple A13 Bionic chip as well as an ultra-wide dual-camera system.",
//      "photoFilename": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.jpg",
//      "isReview": true,
//      "productWebsite": "https://www.amazon.com/Apple-Carrier-Subscription-Cricket-Wireless/dp/B084GT5CBS/ref=asc_df_B084GT5CBS?mcid=37fb976713e5310d88720ee4a5b64375&hvocijid=11255873999392308359-B084GT5CBS-&hvexpln=73&tag=hyprod-20&linkCode=df0&hvadid=692875362841&hvpos=&hvnetw=g&hvrand=11255873999392308359&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9008142&hvtargid=pla-2281435182138&th=1"
//
//      "userRating": 4.0,
//      "textReview": "I like this"
//      "userImageName": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.jpg"
//      "userVideoName": "ED286A58-689E-4B65-90B7-BF7EE65E0CD1.mp4",
//      "audioNoteFilename": "8E04045D-EC1F-4A09-ACA1-6E2F06CE8E68.m4a"
//      "speechToText": "I hate this"
//}

struct FoodStruct: Decodable, Encodable{
    let name: String
    let fat_total_g: Double
    let fat_saturated_g: Double
    let sodium_mg: Int
    let potassium_mg: Int
    let cholesterol_mg: Int
    let carbohydrates_total_g: Double
    let fiber_g: Double
    let sugar_g: Double
}

struct NewsStruct: Decodable, Encodable{

    var title: String
    var name: String
    var authors: String
    var link: String
    var thumbnail: String
    var date: String
    
    
    /*
       "news_results": [
         {
           "position": 1,
           "title": "Industrial Taphouse owners opening Steampunk Pizza in Ashland",
           "source": {
             "name": "RichmondBizSense",
             "icon": "https://encrypted-tbn0.gstatic.com/faviconV2?url=https://richmondbizsense.com&client=NEWS_360&size=96&type=FAVICON&fallback_opts=TYPE,SIZE,URL",
             "authors": [
               "Mike Platania"
             ]
           },
           "link": "https://richmondbizsense.com/2024/11/12/industrial-taphouse-owners-opening-steampunk-pizza-in-ashland/",
           "thumbnail": "https://richmondbizsense.com/wp-content/uploads/2024/11/steampunk-pizza1-Cropped.jpg",
           "thumbnail_small": "https://news.google.com/api/attachments/CC8iI0NnNDVjM3BhYjFwZlJreG1aV05ZVFJDb0FSaXNBaWdCTWdB",
           "date": "11/12/2024, 09:03 AM, +0200 EET"
         },
         ...
       ]
     }
     */
}

struct DefinitionStruct: Decodable, Encodable{
    
    var word: String
    var origin: String
    var meanings: String
    var partOfSpeech: String
    var definition: String
    var example: String
    var synonyms: String
    var antonyms: String
    
    /*
     [
         {
           "word": "hello",
           "phonetic": "həˈləʊ",
           "phonetics": [
             {
               "text": "həˈləʊ",
               "audio": "//ssl.gstatic.com/dictionary/static/sounds/20200429/hello--_gb_1.mp3"
             },
             {
               "text": "hɛˈləʊ"
             }
           ],
           "origin": "early 19th century: variant of earlier hollo ; related to holla.",
           "meanings": [
             {
               "partOfSpeech": "exclamation",
               "definitions": [
                 {
                   "definition": "used as a greeting or to begin a phone conversation.",
                   "example": "hello there, Katie!",
                   "synonyms": [],
                   "antonyms": []
                 }
               ]
             },
             {
               "partOfSpeech": "noun",
               "definitions": [
                 {
                   "definition": "an utterance of ‘hello’; a greeting.",
                   "example": "she was getting polite nods and hellos from people",
                   "synonyms": [],
                   "antonyms": []
                 }
               ]
             },
             {
               "partOfSpeech": "verb",
               "definitions": [
                 {
                   "definition": "say or shout ‘hello’.",
                   "example": "I pressed the phone button and helloed",
                   "synonyms": [],
                   "antonyms": []
                 }
               ]
             }
           ]
         }
       ]
     */
    
}
