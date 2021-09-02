//
//  OpenChargeAppTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 02/09/2021.
//

import XCTest
@testable import OpenChargeApp

protocol HTTPClient {
    func get(from url: URL)
}

class OpenChargeLoader {
    private let baseAPIURL = "https://api.openchargemap.io/v3/poi/"
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"

    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "\(baseAPIURL)")!)
    }
}

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
