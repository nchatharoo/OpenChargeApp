//
//  LocationManagerTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 08/09/2021.
//

import XCTest
import CoreLocation
import Combine
import OpenChargeApp

class LocationManagerMock: CLLocationManager {
    let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Error>()

    public override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        self.delegate = self
        self.requestWhenInUseAuthorization()
    }
}

extension LocationManagerMock: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationSubject.send(location.coordinate)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationSubject.send(completion: .failure(error))
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationSubject.send(manager.authorizationStatus)
    }
}

extension LocationManagerMock: LocationManagerPublisher {
    func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return Just(CLLocationManager().authorizationStatus)
            .merge(with: authorizationSubject)
            .eraseToAnyPublisher()
    }
    
    func locationPublisher() -> AnyPublisher<CLLocationCoordinate2D, Error> {
        return locationSubject.eraseToAnyPublisher()
    }
}

class LocationManagerTests: XCTestCase {
        
    func test_delegateIsNotNil() {
        let sut = makeSUT()
        XCTAssertNotNil(sut.delegate)
    }
    
    func test_didUpdateLocations() {
        let sut = makeSUT()
        let locations = [CLLocation(latitude: 10, longitude: 10), CLLocation(latitude: 20, longitude: 20)]
        sut.locationManager(sut, didUpdateLocations: locations)
    }
        
    // MARK: Helpers

    private func makeSUT() -> LocationManagerMock {
        return LocationManagerMock()
    }
}
