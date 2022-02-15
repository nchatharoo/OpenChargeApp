//
//  LocationViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
//

import Foundation
import MapKit
import Combine
import SwiftUI

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

struct LocationError: Error, Identifiable {
    let id = UUID()
    var title = "Please"
    var message = "Allow access to your location"
}

public class LocationViewModel: ObservableObject {
    private let locationManager: LocationManager
    @Published public var coordinateRegion = MKCoordinateRegion()
    @Published var isDeniedOrRestricted: Bool = false
    var locationError = LocationError()
    
    public init() {
        self.locationManager = LocationManager()
        self.getAuthorizationStatus()
        self.requestLocationUpdates()
    }
    
    func getAuthorizationStatus() {
        _ = locationManager.authorizationPublisher()
            .receive(on: RunLoop.main)
            .map { authorization in
                switch authorization {
                case .denied, .restricted:
                    self.isDeniedOrRestricted = true
                case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                    break
                @unknown default:
                    break
                }
            }
    }
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        default:
            locationManager.stopUpdatingLocation()
        }
    }
}
