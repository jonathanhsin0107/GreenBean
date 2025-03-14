// ProductDetails.swift
import SwiftUI
import MapKit
import CoreLocation

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct ProductDetails: View {
    // Input Parameter
    let product: Product
    
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    var body: some View {
        return AnyView(
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
                Section(header: Text("Store Location on Map")) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .scaledToFit()
                    
                    NavigationLink(destination: StoreLocationOnMap(store: product.store, location: product.location, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Show Store Location on Map")
                                .font(.system(size: 16))
                                .foregroundColor(.blue)
                        }
                    }
                    .scaledToFit()
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
        )
        .font(.system(size: 14))
        .navigationTitle(product.productName)
        .toolbarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {}
        }, message: {
            Text(alertMessage)
        })
    }
    struct StoreLocationOnMap: View {
        
        // Input Parameters
        let store: String
        let location: String
        let mapStyleIndex: Int
        
        @State private var mapCenterCoordinate: CLLocationCoordinate2D? = nil
        @State private var mapCameraPosition: MapCameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        var body: some View {
            VStack {
                if let coordinate = mapCenterCoordinate {
                    Map(position: $mapCameraPosition) {
                        Marker(store, coordinate: coordinate)
                    }
                    .mapStyle(getMapStyle())
                    .navigationTitle(store)
                    .toolbarTitleDisplayMode(.inline)
                } else {
                    ProgressView("Loading location...")
                }
            }
            .onAppear {
                geocodeLocation()
            }
        }
        /// Geocode the location and update the state
            private func geocodeLocation() {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(location) { placemarks, error in
                    if let error = error {
                        print("Geocoding error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let placemark = placemarks?.first, let loc = placemark.location else {
                        print("No valid location found.")
                        return
                    }
                    
                    let newCoordinate = loc.coordinate
                    
                    DispatchQueue.main.async {
                        self.mapCenterCoordinate = newCoordinate
                        self.mapCameraPosition = .region(
                            MKCoordinateRegion(
                                center: newCoordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        )
                    }
                }
            }
            
            /// Get the correct MapStyle based on user selection
            private func getMapStyle() -> MapStyle {
                switch mapStyleIndex {
                case 0: return .standard
                case 1: return .imagery     // Satellite
                case 2: return .hybrid
                case 3: return .hybrid(elevation: .realistic)   // Globe
                default: return .standard
                }
            }
        }
}
