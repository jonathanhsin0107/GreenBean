// ProductDetails.swift
import SwiftUI
import MapKit

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct ProductDetails: View {
    // Input Parameter
    let product: Product
    
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        Form {
            Section(header: Text("Product Name")) {
                Text(product.productName)
            }
            Section(header: Text("Brand")) {
                Text(product.brand)
            }
            Section(header: Text("Category")) {
                Text(product.category)
            }
            Section(header: Text("Photo Image")) {
                AsyncImage(url: URL(string: product.imageLink)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    } else {
                        Image(systemName: "photo")
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    }
                }
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = product.imageLink
                        showAlertMessage = true
                        alertTitle = "Image Link is Copied to Clipboard"
                        alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                    }) {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Image Link")
                    }
                }
            }
            Section(header: Text("Price")) {
                Text(product.price)
            }
            Section(header: Text("Size")) {
                Text(product.size)
            }
            Section(header: Text("Price Per Unit")) {
                Text(product.pricePerUnit)
            }
            Section(header: Text("Store")) {
                Text(product.store)
            }
            Section(header: Text("Location")) {
                Text(product.location)
            }
            Section(header: Text("Website")) {
                Link(destination: URL(string: product.websiteURL)!) {
                    HStack {
                        Image(systemName: "globe")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                        Text("Show Website")
                            .font(.system(size: 16))
                    }
                }
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.url = URL(string: product.websiteURL)!
                        showAlertMessage = true
                        alertTitle = "Website URL is Copied to Clipboard"
                        alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                    })
                    {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Website URL")
                    }
                }
            }
        }
        .font(.system(size: 14))
        .navigationTitle(product.productName)
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    }
}
