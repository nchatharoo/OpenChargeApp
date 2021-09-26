//
//  URLSessionHTTPClientTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 04/09/2021.
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
    
    
    func test_getFromURL_failsOnRequestError() {
        
        let url = URL(string: "https://api.openchargemap.io/v3/poi/?key=6bdc7787-1e5b-4567-920a-9a77632ccb96&longitude=-1.248&latitude=45.872&verbose=false&compact=true&output=json&maxresults=10")!
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
        let url = URL(string: "https://api.openchargemap.io/v3/poi/?key=6bdc7787-1e5b-4567-920a-9a77632ccb96&output=json&latitude=0.0&longitude=0.0&maxresults=10&compact=true&verbose=false")!
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        URLSessionHTTPClient().get(from: url, with: stubCoordinate) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: Helpers
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?

        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
