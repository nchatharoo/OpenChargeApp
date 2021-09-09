//
//  LocationManagerTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 08/09/2021.
//

import XCTest
import CoreLocation

protocol LocationManagerInterface {
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
}

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManagerInterface, didUpdateLocations locations: [CLLocation])
}

extension CLLocationManager: LocationManagerInterface {
    var locationManagerDelegate: LocationManagerDelegate? {
        get { return delegate as! LocationManagerDelegate? }
        set { delegate = newValue as! CLLocationManagerDelegate? }
    }
}

class LocationManager: NSObject {

    var locationManager: LocationManagerInterface
    
    private var currentLocationCallback: ((CLLocation) -> Void)?
    
    init(locationManager: LocationManagerInterface = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.locationManagerDelegate = self
    }

    func requestLocationCompletion(completion: @escaping (CLLocation) -> Void) {
        currentLocationCallback = {  (location) in
            completion(location)
        }
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager(manager, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager(manager, didFailWithError: error)
    }
}

extension LocationManager: LocationManagerDelegate {
    func locationManager(_ manager: LocationManagerInterface, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.currentLocationCallback?(location)
        self.currentLocationCallback = nil
    }
}

class LocationManagerTests: XCTestCase {
    
    struct LocationManagerMock: LocationManagerInterface {
        
        var locationManagerDelegate: LocationManagerDelegate?
            
        var locationToReturn: (()->CLLocation)?
        
        func requestWhenInUseAuthorization() {
            guard let location = locationToReturn?() else { return }
            locationManagerDelegate?.locationManager(self, didUpdateLocations: [location])
        }
    }
        
    func test_delegateIsNotNil() {
        let sut = LocationManager()
        
        XCTAssertNotNil(sut.locationManager.locationManagerDelegate)
    }
    
    func test_requestLocation() {
        var mock = LocationManagerMock()

        mock.locationToReturn = {
            return CLLocation(latitude: 10.0, longitude: 10.0)
        }
        
        let sut = LocationManager(locationManager: mock)

        let expectedLocation = CLLocation(latitude: 10.0, longitude: 10.0)
        let completionExpectation = expectation(description: "completion expectation")
                
        sut.requestLocationCompletion { (location) in
            completionExpectation.fulfill()
            XCTAssertEqual(location.coordinate.latitude,expectedLocation.coordinate.latitude)
            XCTAssertEqual(location.coordinate.longitude,expectedLocation.coordinate.longitude)
        }
        wait(for: [completionExpectation], timeout: 1)
    }
}
