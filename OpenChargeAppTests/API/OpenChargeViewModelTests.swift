//
//  OpenChargeViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 13/09/2021.
//

import XCTest
import OpenChargeApp
import MapKit
import Combine

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    public func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (HTTPClient.Result) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        let queryItems = URLQueryItem(name: "key", value: apiKey)
        let queryOutput = URLQueryItem(name: "output", value: "json")
        let queryLat = URLQueryItem(name: "latitude", value: String(45.872))
        let queryLong = URLQueryItem(name: "longitude", value: String(-1.248))
        let queryMaxResults = URLQueryItem(name: "maxresults", value: "10")
        let queryCompact = URLQueryItem(name: "compact", value: "true")
        let queryVerbose = URLQueryItem(name: "verbose", value: "false")
        
        urlComponents.queryItems = [queryItems, queryOutput, queryLat, queryLong, queryMaxResults, queryCompact, queryVerbose]
        
        guard let finalURL = urlComponents.url else {
            return
        }
        messages.append((finalURL, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}


class OpenChargeViewModelTests: XCTestCase {

    func test_initDoesNotLoadItemsOnCreation() {
        let sut = ChargePointViewModel(client: HTTPClientSpy())
        
        XCTAssertTrue(sut.chargePoints.isEmpty)
    }
    
    func testDoesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: ChargePointViewModel? = ChargePointViewModel(client: client)
        
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        sut?.loadChargePoints(with: stubCoordinate)
        sut = nil
        
        XCTAssertEqual(sut?.cancellables, nil)
    }
}
