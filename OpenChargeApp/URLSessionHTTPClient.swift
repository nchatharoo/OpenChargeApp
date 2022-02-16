//
//  URLSessionHTTPClient.swift
//  OpenChargeApp
//
//  Created by Nadheer on 13/09/2021.
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
    
    public func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (HTTPClient.Result) -> Void) {
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        
        let queryItems = URLQueryItem(name: "key", value: apiKey)
        let queryOutput = URLQueryItem(name: "output", value: "json")
        let queryLat = URLQueryItem(name: "latitude", value: String(coordinate.latitude))
        let queryLong = URLQueryItem(name: "longitude", value: String(coordinate.longitude))
        let queryMaxResults = URLQueryItem(name: "maxresults", value: "10")
        let queryCompact = URLQueryItem(name: "compact", value: "true")
        let queryVerbose = URLQueryItem(name: "verbose", value: "false")
        
        urlComponents.queryItems = [queryItems, queryOutput, queryLat, queryLong, queryMaxResults, queryCompact, queryVerbose]
        
        guard let finalURL = urlComponents.url else {
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
}
