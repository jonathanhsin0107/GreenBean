// ProductItem.swift
import SwiftUI
import SwiftData

struct ProductItem: View {
    //let product: Product
    @Environment(\.modelContext) private var modelContext
    @Bindable var product: Product
    
    var body: some View {
        HStack {
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
        }   // End of HStack
        
        Spacer()
        Button(action: {
            product.isFavorite.toggle()
            try? modelContext.save()
        })
        {
            Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .font(.title2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
