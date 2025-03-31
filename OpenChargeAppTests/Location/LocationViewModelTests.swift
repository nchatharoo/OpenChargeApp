//
//  LocationViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 10/09/2021.
//  Updated to latest Swift on 31/03/2025
//

import XCTest
import OpenChargeApp
import MapKit
import Combine
import CoreLocation

class MockLocationManager: LocationManager {
    var authorizationStatusToReturn: CLAuthorizationStatus = .notDetermined
    var locationToReturn: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
    
    private let authorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    private let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()
    
    var didRequestWhenInUseAuthorization = false
    var didStartUpdatingLocation = false
    var didStopUpdatingLocation = false
    
    override var authorizationStatus: CLAuthorizationStatus {
        return authorizationStatusToReturn
    }
    
    override func requestWhenInUseAuthorization() {
        didRequestWhenInUseAuthorization = true
        authorizationSubject.send(authorizationStatusToReturn)
    }
    
    override func startUpdatingLocation() {
        didStartUpdatingLocation = true
        locationSubject.send(locationToReturn)
    }
    
    override func stopUpdatingLocation() {
        didStopUpdatingLocation = true
    }
    
    override func authorizationPublisher() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return authorizationSubject.eraseToAnyPublisher()
    }
    
    override func locationPublisher() -> AnyPublisher<CLLocationCoordinate2D, Never> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    func simulateAuthorizationChange(to status: CLAuthorizationStatus) {
        authorizationStatusToReturn = status
        authorizationSubject.send(status)
    }
    
    func simulateLocationUpdate(to coordinate: CLLocationCoordinate2D) {
        locationToReturn = coordinate
        locationSubject.send(coordinate)
    }
}

class LocationViewModelTests: XCTestCase {
    
    func test_init_doesNotRequestLocationUpdates() {
        let locationManager = MockLocationManager()
        locationManager.authorizationStatusToReturn = .notDetermined
        
        _ = makeViewModel(locationManager: locationManager)
        
        XCTAssertFalse(locationManager.didStartUpdatingLocation)
    }
    
    func test_requestLocationUpdates_whenAuthorizationStatusIsNotDetermined_requestsWhenInUseAuthorization() {
        let locationManager = MockLocationManager()
        locationManager.authorizationStatusToReturn = .notDetermined
        
        let sut = makeViewModel(locationManager: locationManager)
        sut.requestLocationUpdates()
        
        XCTAssertTrue(locationManager.didRequestWhenInUseAuthorization)
        XCTAssertFalse(locationManager.didStartUpdatingLocation)
    }
    
    func test_requestLocationUpdates_whenAuthorizationStatusIsAuthorizedWhenInUse_startsUpdatingLocation() {
        let locationManager = MockLocationManager()
        locationManager.authorizationStatusToReturn = .authorizedWhenInUse
        
        let sut = makeViewModel(locationManager: locationManager)
        sut.requestLocationUpdates()
        
        XCTAssertTrue(locationManager.didStartUpdatingLocation)
    }
    
    func test_requestLocationUpdates_whenAuthorizationStatusIsDenied_stopsUpdatingLocation() {
        let locationManager = MockLocationManager()
        locationManager.authorizationStatusToReturn = .denied
        
        let sut = makeViewModel(locationManager: locationManager)
        sut.requestLocationUpdates()
        
        XCTAssertTrue(locationManager.didStopUpdatingLocation)
    }
    
    func test_authorizationChange_whenDenied_setsIsDeniedOrRestrictedToTrue() {
        let locationManager = MockLocationManager()
        locationManager.authorizationStatusToReturn = .notDetermined
        
        let sut = makeViewModel(locationManager: locationManager)
        
        locationManager.simulateAuthorizationChange(to: .denied)
        
        XCTAssertTrue(sut.isDeniedOrRestricted)
    }
    
    func test_locationUpdate_updatesCurrentLocation() {
        let locationManager = MockLocationManager()
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        
        let sut = makeViewModel(locationManager: locationManager)
        
        locationManager.simulateLocationUpdate(to: expectedCoordinate)
        
        XCTAssertEqual(sut.currentLocation?.latitude, expectedCoordinate.latitude)
        XCTAssertEqual(sut.currentLocation?.longitude, expectedCoordinate.longitude)
    }
    
    func test_locationUpdate_updatesRegion() {
        let locationManager = MockLocationManager()
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        
        let sut = makeViewModel(locationManager: locationManager)
        
        locationManager.simulateLocationUpdate(to: expectedCoordinate)
        
        XCTAssertEqual(sut.region.center.latitude, expectedCoordinate.latitude)
        XCTAssertEqual(sut.region.center.longitude, expectedCoordinate.longitude)
    }
    
    // MARK: - Helpers
    
    private func makeViewModel(locationManager: MockLocationManager) -> LocationViewModel {
        let viewModel = LocationViewModel()
        // Use reflection to replace the locationManager with our mock
        let mirror = Mirror(reflecting: viewModel)
        if let locationManagerProperty = mirror.children.first(where: { $0.label == "locationManager" }) {
            let locationManagerObject = locationManagerProperty.value as AnyObject
            // Swizzle the locationManager property with our mock
            object_setClass(locationManagerObject, type(of: locationManager))
        }
        return viewModel
    }
}
