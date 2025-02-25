//
//  Item.swift
//  GreenBean
//
//  Created by Jonathan on 2/25/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
