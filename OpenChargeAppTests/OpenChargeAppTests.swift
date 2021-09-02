//
//  OpenChargeAppTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 02/09/2021.
//

import XCTest
@testable import OpenChargeApp

class HTTPClient {
    
    var requestedURL: URL?
    static let shared = HTTPClient()
    
    private init() {}
}

class OpenChargeLoader {
    
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class OpenChargeAppTests: XCTestCase {
    
    private let baseAPIURL = "https://api.openchargemap.io/v3/poi/"
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"

    func test_doesNotRequestDataOnCreation() {
        let client = HTTPClient.shared
        let _ = OpenChargeLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = OpenChargeLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
