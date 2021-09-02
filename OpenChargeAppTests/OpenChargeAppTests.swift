//
//  OpenChargeAppTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 02/09/2021.
//

import XCTest
@testable import OpenChargeApp

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

class OpenChargeAppTests: XCTestCase {

    func test_doesNotRequestDataOnCreation() {
        let (_, client) = makeSUT()

        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()

        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    func test_load_requestDataTwice() {
        let (sut, client) = makeSUT()
        
        sut.load()
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: OpenChargeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = OpenChargeLoader(client: client)
        return (sut, client)
    }
}
