//
//  Search.swift
//  GreenBean
//
//  Created by Osman Balci on 10/20/24.
//  Modified by Jonathan on 2/25/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import SwiftUI
import SwiftData

struct Search: View {
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Product>(sortBy: [SortDescriptor(\Product.productName, order: .forward)])) private var listOfAllProductsInDatabase: [Product]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    
    // Search Bar: 1 of 4 --> searchText contains the search query entered by the user
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                // Search Bar: 2 of 4 --> Use filteredPhoto
                ForEach(filteredProducts) { aProduct in
                    NavigationLink(destination: ProductDetails(product: aProduct)) {
                        ProductItem(product: aProduct)

                    }
                }
                .onDelete(perform: delete)
                
            }   // End of List
            .font(.system(size: 14))
            .navigationTitle("Search Products")
            .toolbarTitleDisplayMode(.inline)
            
        }   // End of NavigationStack
        // Search Bar: 3 of 4 --> Attach 'searchable' modifier to the NavigationStack
        .searchable(text: $searchText, prompt: "Search a Product through Name or Store")
        
    }   // End of body var
    
    // Search Bar: 4 of 4 --> Compute filtered results
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            listOfAllProductsInDatabase
        } else {
            listOfAllProductsInDatabase.filter {
                $0.productName.localizedStandardContains(searchText) ||
                $0.store.localizedStandardContains(searchText)
            }
        }
    }

    func delete(at offsets: IndexSet) {
        
        toBeDeleted = offsets
        showConfirmation = true
    }
} // End of struct

#Preview {
    Search()
}

