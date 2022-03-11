//
//  ChargerViewModelTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 11/03/2022.
//

import XCTest
import OpenChargeApp

func uniqueCharger() -> Charger {
    return Charger(dataProvider: nil, operatorInfo: nil, usageType: nil, statusType: nil, submissionStatus: nil, userComments: nil, percentageSimilarity: nil, mediaItems: nil, isRecentlyVerified: nil, dateLastVerified: nil, id: nil, uuid: UUID().uuidString, parentChargePointID: nil, dataProviderID: nil, dataProvidersReference: nil, operatorID: nil, operatorsReference: nil, usageTypeID: nil, usageCost: nil, addressInfo: nil, connections: nil, numberOfPoints: nil, generalComments: nil, datePlanned: nil, dateLastConfirmed: nil, statusTypeID: nil, dateLastStatusUpdate: Date(), dataQualityLevel: nil, dateCreated: Date(), submissionStatusTypeID: nil)
}

class ChargerViewModelTests: XCTestCase {

    func test_init_with_charger() {
        let charger = uniqueCharger()
        
        let sut = ChargerViewModel(charger: charger)
        
        XCTAssertNotNil(sut.charger)
    }

}
