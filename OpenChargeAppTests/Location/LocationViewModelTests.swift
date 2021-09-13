//
//  LocationViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 10/09/2021.
//

import XCTest
import OpenChargeApp
import MapKit

class LocationViewModel: NSObject {
    let locationManager: LocationManager
    var coordinateRegion: MKCoordinateRegion?

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
    }

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

}
