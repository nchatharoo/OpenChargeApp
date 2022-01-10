//
//  OpenChargeViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 13/09/2021.
//

import XCTest
import OpenChargeApp
import MapKit

class OpenChargeViewModel {
    let openchargeloader: OpenChargeLoader
    var item = ChargePoint()
    
    init(openchargeloader: OpenChargeLoader) {
        self.openchargeloader = openchargeloader
    }
    
    func loadItem(completion: @escaping (OpenChargeLoader.Result) -> Void) {
        self.openchargeloader.load(with: CLLocationCoordinate2D()) { result in
            switch result {
            case let .success(items):
                self.item = items
                print(items)
            case let .failure(error):
                print(error)
            }
            completion(result)
        }
    }
}

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
        
        sut.loadItem { results in
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
