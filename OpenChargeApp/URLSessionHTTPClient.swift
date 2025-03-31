//
//  URLSessionHTTPClient.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
//  Updated to latest Swift on 31/03/2025
//

import Foundation
import MapKit

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"

    struct UnexpectedValuesRepresentation: Error {}

    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Legacy method for backward compatibility
    public func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (HTTPClient.Result) -> Void) {
        guard let finalURL = createFinalURL(from: url, with: coordinate) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        session.dataTask(with: finalURL) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }.resume()
    }
    
    // Modern async/await implementation
    public func get(from url: URL, with coordinate: CLLocationCoordinate2D) async throws -> (Data, HTTPURLResponse) {
        guard let finalURL = createFinalURL(from: url, with: coordinate) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: finalURL)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw UnexpectedValuesRepresentation()
        }
        
        return (data, httpResponse)
    }
    
    // Helper method to create the final URL with query parameters
    private func createFinalURL(from url: URL, with coordinate: CLLocationCoordinate2D) -> URL? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        let queryItems = URLQueryItem(name: "key", value: apiKey)
        let queryOutput = URLQueryItem(name: "output", value: "json")
        let queryLat = URLQueryItem(name: "latitude", value: String(coordinate.latitude))
        let queryLong = URLQueryItem(name: "longitude", value: String(coordinate.longitude))
        let queryMaxResults = URLQueryItem(name: "maxresults", value: "100")
        let queryCompact = URLQueryItem(name: "compact", value: "false")
        let queryVerbose = URLQueryItem(name: "verbose", value: "true")
        
        urlComponents.queryItems = [queryItems, queryOutput, queryLat, queryLong, queryMaxResults, queryCompact, queryVerbose]
        
        return urlComponents.url
    }
}
