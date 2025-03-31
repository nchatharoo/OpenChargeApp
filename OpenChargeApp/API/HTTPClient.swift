//
//  HTTPClient.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//  Updated to latest Swift on 31/03/2025
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
    
    // Legacy method for backward compatibility
    func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (Result) -> Void)
    
    // Modern async/await method
    func get(from url: URL, with coordinate: CLLocationCoordinate2D) async throws -> (Data, HTTPURLResponse)
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
    
    // Default implementation for backward compatibility
    func get(from url: URL, with coordinate: CLLocationCoordinate2D) async throws -> (Data, HTTPURLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            get(from: url, with: coordinate) { result in
                continuation.resume(with: result)
            }
        }
    }
}
