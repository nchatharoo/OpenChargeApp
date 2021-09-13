//
//  LocationViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 10/09/2021.
//

import XCTest
import OpenChargeApp
import MapKit

class LocationViewModelTests: XCTestCase {
    
    func test_initDoesNotGetLocation() {
        let mock = LocationManagerMock()
        mock.locationToReturn = {
            return CLLocation(latitude: 10, longitude: 10)
        }
        let locationManager = LocationManager(locationManager: mock)
        let sut = LocationViewModel(locationManager: locationManager)
        
        XCTAssertNil(sut.coordinateRegion)
    }

    func test_getLocation() {
        let mock = LocationManagerMock()
        mock.locationToReturn = {
            return CLLocation(latitude: 10, longitude: 10)
        }
        let locationManager = LocationManager(locationManager: mock)
        let sut = LocationViewModel(locationManager: locationManager)

        var expectedCoordinate: MKCoordinateRegion?
        let completionExpectation = expectation(description: "completion expectation")

        sut.getLocation { location in
            expectedCoordinate = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            completionExpectation.fulfill()
            XCTAssertNotNil(expectedCoordinate)
        }
        wait(for: [completionExpectation], timeout: 1)
    }
}
