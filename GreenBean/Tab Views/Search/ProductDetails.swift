//
//  ApartmentDetails.swift
//  Blacksburg
//
//  Created by Osman Balci on 9/4/24.
//  Copyright © 2024 Osman Balci. All rights reserved.
//

import SwiftUI
import MapKit

fileprivate var mapCenterCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct ProductDetails: View {
    
    // Input Parameter
    let product: Product
    
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    var transportTypes = ["Automobile", "Transit", "Walking"]
    @State private var selectedTransportTypeIndex = 0
    
    @State private var showAlertMessage = false
    
    var body: some View {
        
        mapCenterCoordinate = CLLocationCoordinate2D(latitude: apartment.latitude, longitude: apartment.longitude)
        
        return AnyView(
            Form {
                Section(header: Text("Apartment Name")) {
                    Text(apartment.name)
                }
                Section(header: Text("Apartment Photo")) {
                    Image(apartment.photoFilename)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                    // Long press the photo image to display the context menu
                        .contextMenu {
                            // Context Menu Item
                            Button(action: {
                                // Copy the apartment photo to universal clipboard for pasting elsewhere
                                UIPasteboard.general.image = UIImage(named: apartment.photoFilename)
                                
                                showAlertMessage = true
                                alertTitle = "Photo is Copied to Clipboard"
                                alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Copy Image")
                            }
                        }
                }
                Section(header: Text("Apartment Phone Number")) {
                    // Tap the phone number to display the Call phone number interface
                    HStack {
                        Image(systemName: "phone")
                            .imageScale(.medium)
                            .font(Font.title.weight(.light))
                            .foregroundColor(Color.blue)
                        
                        //**************************************************************************
                        // This Link does not work on the Simulator since Phone app is not available
                        //**************************************************************************
                        Link(apartment.phoneNumber, destination: URL(string: phoneNumberToCall(phoneNumber: apartment.phoneNumber))!)
                    }
                    // Long press the phone number to display the context menu
                    .contextMenu {
                        // Context Menu Item 1
                        //**************************************************************************
                        // This Link does not work on the Simulator since Phone app is not available
                        //**************************************************************************
                        Link(destination: URL(string: phoneNumberToCall(phoneNumber: apartment.phoneNumber))!) {
                            Image(systemName: "phone")
                            Text("Call")
                        }
                        
                        // Context Menu Item 2
                        Button(action: {
                            // Copy the phone number to universal clipboard for pasting elsewhere
                            UIPasteboard.general.string = apartment.phoneNumber
                            
                            showAlertMessage = true
                            alertTitle = "Phone Number is Copied to Clipboard"
                            alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                        }) {
                            Image(systemName: "doc.on.doc")
                            Text("Copy Phone Number")
                        }
                    }
                }
                if apartment.email != "Unavailable" {
                    Section(header: Text("Apartment Email Address")) {
                        // Tap the Email address to display the Mail app externally to send email
                        HStack {
                            Image(systemName: "envelope")
                                .imageScale(.medium)
                                .font(Font.title.weight(.light))
                                .foregroundColor(Color.blue)
                            
                            //*************************************************************************
                            // This Link does not work on the Simulator since Mail app is not available
                            //*************************************************************************
                            Link(apartment.email, destination: URL(string: "mailto:\(apartment.email)")!)
                        }
                        // Long press the email address to display the context menu
                        .contextMenu {
                            // Context Menu Item 1
                            //*************************************************************************
                            // This Link does not work on the Simulator since Mail app is not available
                            //*************************************************************************
                            Link(destination: URL(string: "mailto:\(apartment.email)")!) {
                                Image(systemName: "envelope")
                                Text("Send Email")
                            }
                            
                            // Context Menu Item 2
                            Button(action: {
                                // Copy the email address to universal clipboard for pasting elsewhere
                                UIPasteboard.general.string = apartment.email
                                
                                showAlertMessage = true
                                alertTitle = "Email Address is Copied to Clipboard"
                                alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                            }) {
                                Image(systemName: "doc.on.doc")
                                Text("Copy Email Address")
                            }
                        }
                    }
                }
                Section(header: Text("Apartment Address")) {
                    Text(apartment.address)
                }
                Section(header: Text("Apartment Location on Map")) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .scaledToFit()
                    
                    NavigationLink(destination: ApartmentLocationOnMap(apartment: apartment, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Apartment Location on Map")
                                .font(.system(size: 16))
                        }
                    }
                    .scaledToFit()
                }
                Section(header: Text("Apartment Website")) {
                    // Tap the website URL to display the website externally in default web browser
                    Link(destination: URL(string: apartment.websiteUrl)!) {
                        HStack {
                            Image(systemName: "globe")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Website")
                                .font(.system(size: 16))
                        }
                    }
                    // Long press the website URL to display the context menu
                    .contextMenu {
                        // Context Menu Item
                        Button(action: {
                            // Copy the website URL to universal clipboard for pasting elsewhere
                            UIPasteboard.general.url = URL(string: apartment.websiteUrl)!
                            
                            showAlertMessage = true
                            alertTitle = "Website URL is Copied to Clipboard"
                            alertMessage = "You can paste it on your iPhone, iPad, Mac laptop or Mac desktop each running under your Apple ID"
                        }) {
                            Image(systemName: "doc.on.doc")
                            Text("Copy Website URL")
                        }
                    }
                }
                Section(header: Text("Directions from Current Location")) {
                    
                    Picker("Select Transport Type", selection: $selectedTransportTypeIndex) {
                        ForEach(0 ..< transportTypes.count, id: \.self) { index in
                            Text(transportTypes[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .scaledToFit()
                    
                    /*
                     Obtain the directions from the user's current location to the selected apartment
                     using the selected transport type. Display the directions on map on another screen.
                     */
                    NavigationLink(destination:
                                    DirectionsOnMap(selectedTransportTypeIndex: selectedTransportTypeIndex,
                                                    startCoordinate: getUsersCurrentLocation(),
                                                    endCoordinate: CLLocationCoordinate2D(
                                                        latitude: apartment.latitude,
                                                        longitude: apartment.longitude)
                                                   )
                                        .navigationTitle("\(transportTypes[selectedTransportTypeIndex]) Directions")
                                        .toolbarTitleDisplayMode(.inline)
                    ) {
                        HStack {
                            Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Directions on Map")
                                .font(.system(size: 16))
                        }
                    }
                    .scaledToFit()
                }
                
            }   // End of Form
            .font(.system(size: 14))
            .navigationTitle(apartment.name)
            .toolbarTitleDisplayMode(.inline)
            .alert(alertTitle, isPresented: $showAlertMessage, actions: {
                Button("OK") {}
            }, message: {
                Text(alertMessage)
            })
            
        )   // End of AnyView
    }   // End of body var
    
    func phoneNumberToCall(phoneNumber: String) -> String {
        // phoneNumber = (540) 231-4841
        
        let cleaned1 = phoneNumber.replacingOccurrences(of: " ", with: "")
        let cleaned2 = cleaned1.replacingOccurrences(of: "(", with: "")
        let cleaned3 = cleaned2.replacingOccurrences(of: ")", with: "")
        let cleanedNumber = cleaned3.replacingOccurrences(of: "-", with: "")
        
        // cleanedNumber = 5402314841
        
        return "tel:" + cleanedNumber
    }
    
    struct ApartmentLocationOnMap: View {
        
        // Input Parameters
        let apartment: Apartment
        let mapStyleIndex: Int
        
        @State private var mapCameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                // mapCenterCoordinate is a fileprivate var
                center: mapCenterCoordinate,
                // 1 degree = 69 miles. 0.01 degree = 0.69 miles
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01)
            )
        )
        
        var body: some View {
            
            var mapStyle: MapStyle = .standard
            
            switch mapStyleIndex {
            case 0:
                mapStyle = MapStyle.standard
            case 1:
                mapStyle = MapStyle.imagery     // Satellite
            case 2:
                mapStyle = MapStyle.hybrid
            case 3:
                mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
            default:
                print("Map style is out of range!")
            }
            
            return AnyView(
                Map(position: $mapCameraPosition) {
                    Marker(apartment.name,
                           coordinate: CLLocationCoordinate2D(
                            latitude: apartment.latitude,
                            longitude: apartment.longitude)
                    )
                }
                    .mapStyle(mapStyle)
                    .navigationTitle(apartment.name)
                    .toolbarTitleDisplayMode(.inline)
            )
        }   // End of body var
    }
}

#Preview {
    ApartmentDetails(apartment: apartmentStructList[0])
}
