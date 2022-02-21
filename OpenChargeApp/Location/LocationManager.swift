//
//  LocationManager.swift
//  OpenChargeApp
//
//  Created by Nadheer on 10/09/2021.
//

import Foundation
import Combine
import CoreLocation

public protocol LocationManagerPublisher: AnyObject {
    func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never>
    func locationPublisher() -> AnyPublisher<CLLocationCoordinate2D, Never>
}

public class LocationManager: CLLocationManager {
    let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    public override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        self.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationSubject.send(location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationSubject.send(completion: .finished)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationSubject.send(manager.authorizationStatus)
    }
}

extension LocationManager: LocationManagerPublisher {
    public func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return Just(self.authorizationStatus)
            .merge(with: authorizationSubject)
            .eraseToAnyPublisher()
    }
    
    public func locationPublisher() -> AnyPublisher<CLLocationCoordinate2D, Never> {
        locationSubject.eraseToAnyPublisher()
    }
}
