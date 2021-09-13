//
//  LocationViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
//

import Foundation
import MapKit

public class LocationViewModel {
    let locationManager: LocationManager
    public var coordinateRegion: MKCoordinateRegion?

    public init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }
    
    public func getLocation(completion: @escaping (CLLocation) -> Void) {
        self.locationManager.requestWhenInUseAuthorization { location in
        self.coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            completion(location)
        }
    }
}
