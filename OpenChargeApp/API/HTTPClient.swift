//
//  HTTPClient.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation
import MapKit
import Combine

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (Result) -> Void)
}

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(from url: URL, with coordinate: CLLocationCoordinate2D) -> Publisher {
        
        return Deferred {
            Future { completion in
                self.get(from: url, with: coordinate, completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
}
