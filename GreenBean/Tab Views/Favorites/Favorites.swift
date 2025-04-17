import SwiftUI
import SwiftData

struct Favorites: View {
    // We do a query to fetch Product(s) whose boolean flag (isFavorite) is true.
    @Query(filter: #Predicate<Product> { $0.isFavorite == true }) var favoriteProducts: [Product]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Your Favorites")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                if favoriteProducts.isEmpty{
                    Spacer()
                    Text("No favorites added.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .italic()
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                else {
                    List {                                    // Displays/lists all the favorite products
                        ForEach(favoriteProducts) {           // Goes through array of favorite items
                            product in
                            // We need to make sure that we can access product details when we click on them
                            NavigationLink(destination: ProductDetails (product: product)) {
                                // Basically how the product row looks like on this page
                                ProductItem(product: product)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Favorites()
}
