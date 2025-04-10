
import SwiftUI
import SwiftData
import CoreLocation

struct Search: View {
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Product>(sortBy: [SortDescriptor(\Product.productName, order: .forward)])) private var listOfAllProductsInDatabase: [Product]
    
    @State private var toBeDeleted: IndexSet?
    @State private var showConfirmation = false
    @State private var searchText = ""

    // ✅ Add LocationManager
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {

                // ✅ Optional: Show store detection status
                if let currentStore = locationManager.currentStore {
                    Text("📍 Showing results for: \(currentStore)")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal)
                } else {
                    Text("📍 Searching all stores")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }

                List {
                    ForEach(filteredProducts) { aProduct in
                        NavigationLink(destination: ProductDetails(product: aProduct)) {
                            ProductItem(product: aProduct)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .font(.system(size: 14))
            }
            .navigationTitle("Search Products")
            .toolbarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchText, prompt: "Search a Product through Name or Store")
    }

    // ✅ Location-aware and text-aware filtering
    var filteredProducts: [Product] {
        var base = listOfAllProductsInDatabase
        
        // Filter by nearby store if available
        if let store = locationManager.currentStore {
            base = base.filter {
                $0.store.localizedCaseInsensitiveContains(store)
            }
        }

        // Apply search filtering
        if searchText.isEmpty {
            return base
        } else {
            return base.filter {
                $0.productName.localizedStandardContains(searchText) ||
                $0.store.localizedStandardContains(searchText)
            }
        }
    }

    func delete(at offsets: IndexSet) {
        toBeDeleted = offsets
        showConfirmation = true
    }
}

#Preview {
    Search()
}
