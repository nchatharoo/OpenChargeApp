//
//  OpenChargeAppTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 02/09/2021.
//

import XCTest
import MapKit
@testable import OpenChargeApp

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    public func get(from url: URL, with coordinate: CLLocationCoordinate2D, completion: @escaping (HTTPClientResult) -> Void) {
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
        messages[index].completion(.success(data, response))
    }
}

class OpenChargeLoaderTests: XCTestCase {
    
    func test_doesNotRequestDataOnCreation() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        sut.load(with: stubCoordinate) { _ in }
        
        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_load_requestDataTwice() {
        let (sut, client) = makeSUT()
        
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        sut.load(with: stubCoordinate) { _ in }
        sut.load(with: stubCoordinate) { _ in }

        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let sample = [199, 201, 300, 400, 500]
        
        sample.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .success([]), when: {
                let emptyListJSON = Data("[]".utf8)
                client.complete(withStatusCode: code, data: emptyListJSON, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = Data("[]".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let response: Item? = try? Bundle.main.loadAndDecodeJSON(filename: "response")
        expect(sut, toCompleteWith: .success(response!), when: {
            do {
                let json = try JSONEncoder().encode(response)
                client.complete(withStatusCode: 200, data: json)
            } catch EncodingError.invalidValue( _, let context) {
                print(context)
            } catch {
                print("error: ", error)
            }
        })
    }
    
    func testDoesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        var sut: OpenChargeLoader? = OpenChargeLoader(client: client)
        
        var capturedResults = [OpenChargeLoader.Result]()
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        sut?.load(with: stubCoordinate) { capturedResults.append($0) }

        sut = nil

        let response: Item? = try? Bundle.main.loadAndDecodeJSON(filename: "response")
        let json = try? JSONEncoder().encode(response)
        client.complete(withStatusCode: 200, data: json!)

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: OpenChargeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = OpenChargeLoader(client: client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
    
    private func expect(_ sut: OpenChargeLoader, toCompleteWith result: OpenChargeLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [OpenChargeLoader.Result]()
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        sut.load(with: stubCoordinate) { capturedResults.append($0) }

        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.")
        }
    }
}

extension Bundle {
    
    func loadAndDecodeJSON<D: Decodable>(filename: String) throws -> D? {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        let data = try Data(contentsOf: url)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        do {
            let decodedModel = try jsonDecoder.decode(D.self, from: data)
            return decodedModel
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return nil
    }
}
