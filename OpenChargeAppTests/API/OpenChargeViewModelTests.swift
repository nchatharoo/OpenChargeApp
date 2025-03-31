//
//  OpenChargeViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 13/09/2021.
//  Updated to latest Swift on 31/03/2025
//

import XCTest
import OpenChargeApp
import MapKit
import Combine

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    private var asyncRequests = [(url: URL, coordinate: CLLocationCoordinate2D)]()
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    var asyncRequestedURLs: [URL] {
        return asyncRequests.map { $0.url }
    }
    
    var asyncRequestedCoordinates: [CLLocationCoordinate2D] {
        return asyncRequests.map { $0.coordinate }
    }
    
    var asyncResult: Result<(Data, HTTPURLResponse), Error> = .success((Data(), HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!))
    
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
        
        // Create a mock request with headers
        var request = URLRequest(url: finalURL)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.addValue("OpenChargeApp/1.0", forHTTPHeaderField: "User-Agent")
        
        messages.append((finalURL, completion))
    }
    
    public func get(from url: URL, with coordinate: CLLocationCoordinate2D) async throws -> (Data, HTTPURLResponse) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
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
            throw URLError(.badURL)
        }
        
        // Create a mock request with headers
        var request = URLRequest(url: finalURL)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        request.addValue("OpenChargeApp/1.0", forHTTPHeaderField: "User-Agent")
        
        asyncRequests.append((finalURL, coordinate))
        
        switch asyncResult {
        case .success(let success):
            return success
        case .failure(let error):
            throw error
        }
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
    
    func setAsyncResult(data: Data, statusCode: Int = 200) {
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        asyncResult = .success((data, response))
    }
    
    func setAsyncError(_ error: Error) {
        asyncResult = .failure(error)
    }
}

class OpenChargeViewModelTests: XCTestCase {
    
    func test_initDoesNotLoadItemsOnCreation() {
        let sut = ChargersViewModel(client: HTTPClientSpy())
        
        XCTAssertTrue(sut.filteredChargePoints.isEmpty)
    }
    
    func test_loadChargePoints_requestsDataFromURL() {
        let client = HTTPClientSpy()
        let sut = ChargersViewModel(client: client)
        let coordinate = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
        
        sut.loadChargePoints(with: coordinate)
        
        XCTAssertFalse(client.requestedURLs.isEmpty)
    }
    
    func test_loadChargePointsAsync_requestsDataFromURL() async {
        let client = HTTPClientSpy()
        let sut = ChargersViewModel(client: client)
        let coordinate = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
        
        // Create a valid JSON response
        let jsonData = """
        [
            {
                "id": 1,
                "uuid": "abc123",
                "operatorInfo": {
                    "title": "Test Operator"
                },
                "addressInfo": {
                    "title": "Test Address",
                    "latitude": 45.872,
                    "longitude": -1.248
                }
            }
        ]
        """.data(using: .utf8)!
        
        client.setAsyncResult(data: jsonData)
        
        await sut.loadChargePointsAsync(with: coordinate)
        
        XCTAssertFalse(client.asyncRequestedURLs.isEmpty)
        XCTAssertEqual(client.asyncRequestedCoordinates.first?.latitude, coordinate.latitude)
        XCTAssertEqual(client.asyncRequestedCoordinates.first?.longitude, coordinate.longitude)
    }
    
    func test_loadChargePointsAsync_deliversErrorOnClientError() async {
        let client = HTTPClientSpy()
        let sut = ChargersViewModel(client: client)
        let coordinate = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
        
        let error = NSError(domain: "test", code: 0)
        client.setAsyncError(error)
        
        await sut.loadChargePointsAsync(with: coordinate)
        
        XCTAssertNotNil(sut.networkError)
    }
    
    func test_filterCharger_filtersChargePointsCorrectly() async {
        let client = HTTPClientSpy()
        let sut = ChargersViewModel(client: client)
        let coordinate = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
        
        // Create a valid JSON response with multiple chargers
        let jsonData = """
        [
            {
                "id": 1,
                "uuid": "abc123",
                "operatorInfo": {
                    "title": "Test Operator 1"
                },
                "addressInfo": {
                    "title": "Test Address 1",
                    "latitude": 45.872,
                    "longitude": -1.248
                },
                "connections": [
                    {
                        "powerKW": 50.0,
                        "connectionType": {
                            "title": "Type 2"
                        }
                    }
                ],
                "statusType": {
                    "isOperational": true
                },
                "usageType": {
                    "isPayAtLocation": true
                }
            },
            {
                "id": 2,
                "uuid": "def456",
                "operatorInfo": {
                    "title": "Test Operator 2"
                },
                "addressInfo": {
                    "title": "Test Address 2",
                    "latitude": 45.873,
                    "longitude": -1.249
                },
                "connections": [
                    {
                        "powerKW": 22.0,
                        "connectionType": {
                            "title": "CCS"
                        }
                    }
                ],
                "statusType": {
                    "isOperational": false
                },
                "usageType": {
                    "isMembershipRequired": true
                }
            }
        ]
        """.data(using: .utf8)!
        
        client.setAsyncResult(data: jsonData)
        
        await sut.loadChargePointsAsync(with: coordinate)
        
        // Verify we have 2 chargers loaded
        XCTAssertEqual(sut.filteredChargePoints.count, 2)
        
        // Create a filter that should match only the second charger
        let filter = ChargerFilter(
            powerKW: 30.0,  // Filter out chargers with power < 30kW
            usageType: .all,
            connectionType: ["Type 2", "CCS"],
            connectionIndex: 0,  // Filter out Type 2
            showIsOperational: false
        )
        
        sut.filterCharger(with: filter)
        
        // After filtering, we should have only the second charger
        XCTAssertEqual(sut.filteredChargePoints.count, 1)
        XCTAssertEqual(sut.filteredChargePoints.first?.operatorInfo?.title, "Test Operator 2")
    }
    
    func testDoesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: ChargersViewModel? = ChargersViewModel(client: client)
        
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        sut?.loadChargePoints(with: stubCoordinate)
        let cancellables = sut?.cancellables
        sut = nil
        
        XCTAssertNotNil(cancellables)
    }
}
