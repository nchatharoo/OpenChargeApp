//
//  CLLocationCoordinate2D.swift
//  OpenChargeApp
//
//  Created by Nadheer on 15/02/2022.
//

import MapKit

extension CLLocationCoordinate2D: Equatable {}

public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
}
