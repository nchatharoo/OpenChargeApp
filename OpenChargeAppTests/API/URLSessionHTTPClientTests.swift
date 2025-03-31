//
//  URLSessionHTTPClientTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 04/09/2021.
//  Updated to latest Swift on 31/03/2025
//

import XCTest
import OpenChargeApp
import MapKit

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    // MARK: - Legacy Tests
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://api.openchargemap.io/v3/poi/?key=6bdc7787-1e5b-4567-920a-9a77632ccb96&longitude=-1.248&latitude=45.872&verbose=true&compact=false&output=json&maxresults=10")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        sut.get(from: url, with: stubCoordinate) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = URL(string: "https://api.openchargemap.io/v3/poi/")!
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // Verify that the X-API-Key header is set
            XCTAssertNotNil(request.value(forHTTPHeaderField: "X-API-Key"))
            // Verify that the User-Agent header is set
            XCTAssertEqual(request.value(forHTTPHeaderField: "User-Agent"), "OpenChargeApp/1.0")
            exp.fulfill()
        }
        
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        URLSessionHTTPClient().get(from: url, with: stubCoordinate) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Async/Await Tests
    
    func test_getFromURLAsync_failsOnRequestError() async throws {
        let url = URL(string: "https://api.openchargemap.io/v3/poi/")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        do {
            _ = try await sut.get(from: url, with: stubCoordinate)
            XCTFail("Expected error but got success instead")
        } catch let receivedError as NSError {
            XCTAssertEqual(receivedError.domain, error.domain)
        }
    }
    
    func test_getFromURLAsync_performsGETRequestWithURL() async throws {
        let url = URL(string: "https://api.openchargemap.io/v3/poi/")!
        let stubCoordinate = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
        
        let data = "any data".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        URLProtocolStub.stub(data: data, response: response, error: nil)
        
        let exp = expectation(description: "Wait for request")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.httpMethod, "GET")
            // Verify that the X-API-Key header is set
            XCTAssertNotNil(request.value(forHTTPHeaderField: "X-API-Key"))
            // Verify that the User-Agent header is set
            XCTAssertEqual(request.value(forHTTPHeaderField: "User-Agent"), "OpenChargeApp/1.0")
            exp.fulfill()
        }
        
        let sut = URLSessionHTTPClient()
        
        let task = Task {
            _ = try await sut.get(from: url, with: stubCoordinate)
        }
        
        await fulfillment(of: [exp], timeout: 1.0)
        await task.value
    }
    
    func test_getFromURLAsync_succeedsOnHTTPResponseWithData() async throws {
        let url = URL(string: "https://api.openchargemap.io/v3/poi/")!
        let stubCoordinate = CLLocationCoordinate2D(latitude: 45.872, longitude: -1.248)
        
        let data = "any data".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        URLProtocolStub.stub(data: data, response: response, error: nil)
        
        let sut = URLSessionHTTPClient()
        
        let (receivedData, receivedResponse) = try await sut.get(from: url, with: stubCoordinate)
        
        XCTAssertEqual(receivedData, data)
        XCTAssertEqual(receivedResponse.url, response.url)
        XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
    }
    
    // MARK: Helpers
    private class URLProtocolStub: URLProtocol {
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
            let requestObserver: ((URLRequest) -> Void)?
        }
        
        private static var _stub: Stub?
        private static var stub: Stub? {
            get { return queue.sync { _stub } }
            set { queue.sync { _stub = newValue } }
        }
        
        private static let queue = DispatchQueue(label: "URLProtocolStub.queue")
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error, requestObserver: nil)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let stub = URLProtocolStub.stub else { return }
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }

            stub.requestObserver?(request)
        }
        
        override func stopLoading() {}
    }
}
