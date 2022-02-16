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

public class LocationViewModel: ObservableObject {
    private let locationManager: LocationManager
    @Published var region = MKCoordinateRegion()
    @Published var isDeniedOrRestricted: Bool = false
    var permission = AuthorizationPermission()
    
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
    
    func getLastCoordinate() -> AnyPublisher<CLLocationCoordinate2D, Never> {
        return locationManager.locationPublisher()
    }
}
