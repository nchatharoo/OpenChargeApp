//
//  LocationManager.swift
//  OpenChargeApp
//
//  Created by Nadheer on 10/09/2021.
//

import Foundation
import CoreLocation

public protocol LocationManagerInterface {
    var locationManagerDelegate: LocationManagerDelegate? { get set }
    var accuracyAuthorization: CLAccuracyAuthorization { get }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

public protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManagerInterface, didUpdateLocations locations: [CLLocation])
}


public class LocationManager: NSObject {

    public var locationManager: LocationManagerInterface
    
    private var currentLocationCallback: ((CLLocation) -> Void)?
    
    public init(locationManager: LocationManagerInterface = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        self.locationManager.locationManagerDelegate = self
        switch self.locationManager.accuracyAuthorization {
        case .fullAccuracy:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .reducedAccuracy:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        @unknown default:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        }
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
    }

    public func requestWhenInUseAuthorization(completion: @escaping (CLLocation) -> Void) {
        currentLocationCallback = {  (location) in
            completion(location)
        }
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation(completion: @escaping (CLLocation) -> Void) {
        currentLocationCallback = {  (location) in
            completion(location)
        }
        self.locationManager.requestLocation()
    }
}

extension CLLocationManager: LocationManagerInterface {
    public var locationManagerDelegate: LocationManagerDelegate? {
        get { return delegate as! LocationManagerDelegate? }
        set { delegate = newValue as! CLLocationManagerDelegate? }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.locationManagerDelegate?.locationManager(manager, didUpdateLocations: locations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension LocationManager: LocationManagerDelegate {
    public func locationManager(_ manager: LocationManagerInterface, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocationCallback?(location)
        self.currentLocationCallback = nil
    }
}
