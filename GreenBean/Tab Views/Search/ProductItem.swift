// ProductItem.swift
import SwiftUI

struct ProductItem: View {
    let product: Any
    
    // Computed properties to safely access fields
    private var productName: String {
        if let p = product as? Product {
            return p.productName
        } else if let p = product as? ProductsData {
            return p.productName
        }
        return ""
    }
    
    private var price: String {
        if let p = product as? Product {
            return p.price
        } else if let p = product as? ProductsData {
            return p.price
        }
        return ""
    }
    
    private var size: String {
        if let p = product as? Product {
            return p.size
        } else if let p = product as? ProductsData {
            return p.size
        }
        return ""
    }
    
    private var store: String {
        if let p = product as? Product {
            return p.store
        } else if let p = product as? ProductsData {
            return p.store
        }
        return ""
    }
    
    private var imageLink: String {
        if let p = product as? Product {
            return p.imageLink
        } else if let p = product as? ProductsData {
            return p.imageLink
        }
        return ""
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageLink)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .frame(width: 100.0, height: 100.0)
                } else {
                    ProgressView()
                        .frame(width: 100.0, height: 100.0)
                }
            }
            
            VStack(alignment: .leading) {
                Text(productName)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "tag")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(price.hasPrefix("$") ? price : "$\(price)")
                }
                
                HStack {
                    Image(systemName: "shippingbox")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(size)
                }
                
                HStack {
                    Image(systemName: "cart")
                        .imageScale(.small)
                        .font(Font.title.weight(.thin))
                    Text(store)
                }
            }
            .font(.system(size: 14))
        }
    }
}

#Preview {
    ProductItem(product: productStructList[0])
}
