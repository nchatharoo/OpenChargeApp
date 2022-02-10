//
//  OpenChargeViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 13/09/2021.
//

import XCTest
import OpenChargeApp
import MapKit

class OpenChargeViewModelTests: XCTestCase {

    func test_initDoesNotLoadItemsOnCreation() {
        let openchargeloader = OpenChargeLoader(client: URLSessionHTTPClient())
        let sut = OpenChargeViewModel(openchargeloader: openchargeloader)
        
        XCTAssertTrue(sut.item.isEmpty)
    }
    
    func test_getErrorOnLoadItem() {
        let openchargeloader = OpenChargeLoader(client: URLSessionHTTPClient())
        let sut = OpenChargeViewModel(openchargeloader: openchargeloader)

        var capturedError: OpenChargeLoader.Error?
        let exp = expectation(description: "Wait for completion")
        let stubCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        sut.loadItem(with: stubCoordinate) { results in
            switch results {
            case let .failure(error):
                capturedError = error
                XCTAssertEqual(error, capturedError)
            case .success(_):
                XCTAssertNotNil(sut.item)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
