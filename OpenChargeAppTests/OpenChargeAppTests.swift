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
        let client = HTTPClientSpy()
        let _ = OpenChargeLoader(client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = OpenChargeLoader(client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
