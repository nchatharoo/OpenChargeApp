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
    func locationPublisher() -> AnyPublisher<[CLLocation], Error>
}

public class LocationManager: CLLocationManager {
    let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    let locationSubject = PassthroughSubject<[CLLocation], Error>()
    
    public override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        self.delegate = self
        self.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationSubject.send(locations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationSubject.send(completion: .failure(error))
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationSubject.send(manager.authorizationStatus)
    }
}

extension LocationManager: LocationManagerPublisher {
    public func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return Just(CLLocationManager().authorizationStatus)
            .merge(with: authorizationSubject)
            .eraseToAnyPublisher()
    }
    
    public func locationPublisher() -> AnyPublisher<[CLLocation], Error> {
        return locationSubject.eraseToAnyPublisher()
    }
}
