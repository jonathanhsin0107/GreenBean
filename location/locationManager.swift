//
//  locationManager.swift
//  GreenBean
//
//  Created by Joseph Tran on 4/9/25.
//  Copyright © 2025 Jonathan Hsin. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // Replace with your actual store coordinates
    private let stores: [String: CLLocation] = [
        "Food Lion": CLLocation(latitude: 37.2296, longitude: -80.4139),
        "Kroger": CLLocation(latitude: 37.1296, longitude: -80.4112)
    ]
    
    @Published var currentStore: String? = nil
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        userLocation = latestLocation
        updateNearestStore(userLocation: latestLocation)
    }
    
    private func updateNearestStore(userLocation: CLLocation) {
        for (storeName, storeLocation) in stores {
            let distance = userLocation.distance(from: storeLocation)
            if distance < 100 { // 100 meters radius
                currentStore = storeName
                return
            }
        }
        currentStore = nil // Not near any store
    }
}
