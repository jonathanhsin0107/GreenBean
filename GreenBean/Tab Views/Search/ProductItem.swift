//
//  ApartmentItem.swift
//  Blacksburg
//
//  Created by Osman Balci on 9/4/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI

struct ApartmentItem: View {
    
    // Input Parameter
    let apartment: Apartment
    
    var body: some View {
        HStack {
            Image(apartment.photoFilename)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
            
            VStack(alignment: .leading) {
                Text(apartment.name)

                HStack {
                    Image(systemName: "phone")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(apartment.phoneNumber)
                }
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
            
        }   // End of HStack
    }
}

#Preview {
    ApartmentItem(apartment: apartmentStructList[0])
}
