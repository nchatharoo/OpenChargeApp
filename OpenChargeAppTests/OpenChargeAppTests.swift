//
//  OpenChargeAppTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 02/09/2021.
//

import XCTest
@testable import OpenChargeApp

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (Error) -> Void)]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }

    func get(from url: URL, completion: @escaping (Error) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(error)
    }
}

class OpenChargeAppTests: XCTestCase {

    func test_doesNotRequestDataOnCreation() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let (sut, client) = makeSUT()

        sut.load()
        
        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_load_requestDataTwice() {
        let (sut, client) = makeSUT()
        
        sut.load()
        sut.load()
        
        XCTAssertNotNil(client.requestedURLs)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedError = [OpenChargeLoader.Error]()
        sut.load { capturedError.append($0) }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)

        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: OpenChargeLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = OpenChargeLoader(client: client)
        return (sut, client)
    }
}
