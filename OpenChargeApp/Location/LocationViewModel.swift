//
//  LocationViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
//

import Foundation
import MapKit

public class LocationViewModel: ObservableObject {
    let locationManager: LocationManager
    @Published public var coordinateRegion = MKCoordinateRegion()

    public init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.getLocation()
    }
    
    public func getLocation(completion: @escaping (CLLocation) -> Void = { _ in }) {
        self.locationManager.requestWhenInUseAuthorization { location in
        self.coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
            completion(location)
        }
    }
}
