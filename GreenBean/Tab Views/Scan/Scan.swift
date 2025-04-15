//
//  Scan.swift
//  GreenBean
//
//  Created by Jonathan on 2/25/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import SwiftUI

struct Scan: View {
    //@EnvironmentObject var rewardsAlgo: RewardsAlgorithm
    @Binding var selectedTab: Int
    
    var body: some View {
        //rewardsAlgo.computePoints(spent: 10, event: "")
        
        NavigationStack{
            List{
                NavigationLink(destination: ScanBarCode()){
                    HStack{
                        Image(systemName:"barcode.viewfinder")
                        Text("Scan Bar Code")
                    }
                }
                NavigationLink(destination: ScanReceipt(selectedTab: $selectedTab)){
                    HStack{
                        Image(systemName: "document.viewfinder.fill")
                        Text("Scan Receipt")
                    }
                }
            }
        }
    }
}
