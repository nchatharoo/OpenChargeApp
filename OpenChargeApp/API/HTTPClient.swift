//
//  HTTPClient.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation
import MapKit

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (HTTPClientResult) -> Void)
}
