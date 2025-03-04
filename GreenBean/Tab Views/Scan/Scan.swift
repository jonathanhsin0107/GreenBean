//
//  Scan.swift
//  GreenBean
//
//  Created by Jonathan on 2/25/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import SwiftUI

struct Scan: View {
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(destination: ScanBarCode()){
                    HStack{
                        Image(systemName:"barcode.viewfinder")
                        Text("Scan Bar Code")
                    }
                }
                NavigationLink(destination: ScanReceipt()){
                    HStack{
                        Image(systemName: "document.viewfinder.fill")
                        Text("Scan Receipt")
                    }
                }
            }
        }
    }
}

#Preview {
    Scan()
}
