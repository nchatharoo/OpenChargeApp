//
//  LocationManagerTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 08/09/2021.
//

import XCTest
import CoreLocation
import OpenChargeApp

class LocationManagerMock: LocationManagerInterface {
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    
    var accuracyAuthorization: CLAccuracyAuthorization = .fullAccuracy
    
    var locationManagerDelegate: LocationManagerDelegate?
        
    var locationToReturn: (()->CLLocation)?
    
    func requestWhenInUseAuthorization() {
        guard let location = locationToReturn?() else { return }
        locationManagerDelegate?.locationManager(self, didUpdateLocations: [location])
    }
    
    func requestLocation() {
        guard let location = locationToReturn?() else { return }
        locationManagerDelegate?.locationManager(self, didUpdateLocations: [location])
    }
}

class LocationManagerTests: XCTestCase {
        
    func test_delegateIsNotNil() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.locationManager.locationManagerDelegate)
    }
    
    func test_requestWhenInUseAuthorization() {
        let mock = LocationManagerMock()

        mock.locationToReturn = {
            return CLLocation(latitude: 10.0, longitude: 10.0)
        }
        
        let sut = makeSUT(manager: mock)

        let expectedLocation = CLLocation(latitude: 10.0, longitude: 10.0)
        let completionExpectation = expectation(description: "completion expectation")
                
        sut.requestWhenInUseAuthorization { (location) in
            completionExpectation.fulfill()
            XCTAssertEqual(location.coordinate.latitude,expectedLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude,expectedLocation.coordinate.longitude)
        }
        wait(for: [completionExpectation], timeout: 1)
    }
    
    func test_requestLocation() {
        let mock = LocationManagerMock()
        
        mock.locationToReturn = {
            return CLLocation(latitude: 10.0, longitude: 10.0)
        }
        
        let sut = makeSUT(manager: mock)

        let expectedLocation = CLLocation(latitude: 10.0, longitude: 10.0)
        let completionExpectation = expectation(description: "completion expectation")
                
        sut.requestWhenInUseAuthorization { (location) in
            completionExpectation.fulfill()
            XCTAssertEqual(location.coordinate.latitude, expectedLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude, expectedLocation.coordinate.longitude)
        }
        
        mock.locationToReturn = {
            return CLLocation(latitude: 20.0, longitude: 20.0)
        }
        
        let expectedLocation2 = CLLocation(latitude: 20.0, longitude: 20.0)
        let completionExpectation2 = expectation(description: "completion2 expectation")

        sut.requestLocation { (location) in
            completionExpectation2.fulfill()
            XCTAssertEqual(location.coordinate.latitude, expectedLocation2.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude, expectedLocation2.coordinate.longitude)
        }
        
        wait(for: [completionExpectation, completionExpectation2], timeout: 1)
    }
    
    // MARK: Helpers

    private func makeSUT(manager: LocationManagerInterface = CLLocationManager()) -> LocationManager {
        return LocationManager(locationManager: manager)
    }
}
