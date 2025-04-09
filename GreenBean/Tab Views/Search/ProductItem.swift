// ProductItem.swift
import SwiftUI
import SwiftData

struct ProductItem: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .center) {
            getImageFromUrl(url: product.imageLink, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
            
            VStack(alignment: .leading) {
                Text(product.productName)
                HStack {
                    Image(systemName: "tag")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(product.price.hasPrefix("$") ? product.price : "$\(product.price)")
                }
                HStack {
                    Image(systemName: "shippingbox")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(product.size)
                }
                HStack {
                    Image(systemName: "cart")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(product.store)
                }
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
            
            Spacer()
            Button(action: {
                product.isFavorite.toggle()     // when heart/favorite button is tapped, it changes the boolean flag
            })
            {
                // if isFavorite is true, it will show the filled heart symbol, else normal symbol
                Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}   // End of HStack
