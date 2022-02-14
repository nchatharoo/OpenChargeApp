//
//  LocationViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
//

import Foundation
import MapKit
import Combine

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}

public class LocationViewModel: ObservableObject {
    let locationManager: LocationManager
    @Published public var coordinateRegion = MKCoordinateRegion()
    @Published var status = CLAuthorizationStatus.notDetermined
    var cancellables: Set<AnyCancellable> = []
    @Published var isProcessing = false

    public init() {
        self.locationManager = LocationManager()
        getAuthorizationStatus()
        getLocation()
    }
    
    func getAuthorizationStatus() {
        locationManager.authorizationPublisher()
            .receive(on: RunLoop.main)
            .assign(to: &$status)
    }
    
    public func getLocation() {
        isProcessing = true
        locationManager.locationPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                print(completion)
                self.isProcessing = false
            }, receiveValue: { location in
                guard let lastLocation = location.last else { return }
                self.coordinateRegion = MKCoordinateRegion(center: lastLocation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
            })
            .store(in: &cancellables)
    }
}
