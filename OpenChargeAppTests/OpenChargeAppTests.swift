//
//  OpenChargeAppTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 02/09/2021.
//

import XCTest
@testable import OpenChargeApp

class HTTPClient {
    static var shared = HTTPClient()

    func get(from url: URL) { }
}

class OpenChargeLoader {
    
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    override func get(from url: URL) {
        requestedURL = url
    }
}

class OpenChargeAppTests: XCTestCase {
    
    private let baseAPIURL = "https://api.openchargemap.io/v3/poi/"
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"

    func test_doesNotRequestDataOnCreation() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let _ = OpenChargeLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = OpenChargeLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
