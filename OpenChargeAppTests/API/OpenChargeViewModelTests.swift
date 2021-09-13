//
//  OpenChargeViewModel.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 13/09/2021.
//

import XCTest
import OpenChargeApp

class OpenChargeViewModel {
    let openchargeloader: OpenChargeLoader
    let items = [Item]()
    
    init(openchargeloader: OpenChargeLoader) {
        self.openchargeloader = openchargeloader
    }
}

class OpenChargeViewModelTests: XCTestCase {

    func test_initDoesNotLoadItemsOnCreation() {
        let openchargeloader = OpenChargeLoader(client: URLSessionHTTPClient())
        let sut = OpenChargeViewModel(openchargeloader: openchargeloader)
        
        XCTAssertTrue(sut.items.isEmpty)
    }
}
