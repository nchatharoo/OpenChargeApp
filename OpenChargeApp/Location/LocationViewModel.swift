//
//  LocationViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
//  Updated to latest Swift on 31/03/2025
//

import Foundation
import MapKit
import Combine
import SwiftUI

@MainActor
public class LocationViewModel: ObservableObject {
    private let locationManager: LocationManager
    @Published var region = MKCoordinateRegion()
    @Published var isDeniedOrRestricted: Bool = false
    @Published var currentLocation: CLLocationCoordinate2D?
    var permission = AuthorizationPermission()
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.locationManager = LocationManager()
        setupSubscriptions()
        self.requestLocationUpdates()
    }
    
    private func setupSubscriptions() {
        // Subscribe to authorization changes
        locationManager.authorizationPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] authorization in
                guard let self = self else { return }
                switch authorization {
                case .denied, .restricted:
                    self.isDeniedOrRestricted = true
                case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to location updates
        locationManager.locationPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] coordinate in
                guard let self = self else { return }
                self.currentLocation = coordinate
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
            .store(in: &cancellables)
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
        locationManager.locationPublisher()
            .eraseToAnyPublisher()
    }
    
    // Helper method for testing
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return currentLocation
    }
}
