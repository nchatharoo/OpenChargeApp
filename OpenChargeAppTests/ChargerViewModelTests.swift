//
//  ChargerViewModelTests.swift
//  OpenChargeAppTests
//
//  Created by Nadheer on 11/03/2022.
//

import XCTest
import OpenChargeApp

class ChargerViewModelTests: XCTestCase {

    func test_init_with_charger() {
        let sut = makeSUT()

        XCTAssertNotNil(sut.charger)
    }
    
    //MARK : Operator info
    
    func test_operatorInfoTitle_returnResult() {
        let sut = makeSUT()

        let operatorInfoTitle = sut.charger.operatorInfo?.title
        
        XCTAssertEqual(sut.charger.operatorInfo?.title, operatorInfoTitle)
    }
    
    func test_operatorInfoEmail_returnResult() {
        let sut = makeSUT()

        let operatorInfoEmail = sut.charger.operatorInfo?.contactEmail
        
        XCTAssertEqual(sut.charger.operatorInfo?.contactEmail, operatorInfoEmail)
    }
    
    func test_operatorInfoPrimaryPhone_returnResult() {
        let sut = makeSUT()

        let operatorInfoPrimaryPhone = sut.charger.operatorInfo?.phonePrimaryContact
        
        XCTAssertEqual(sut.charger.operatorInfo?.phonePrimaryContact, operatorInfoPrimaryPhone)
    }
    
    func test_operatorInfoBookingURL_returnResult() {
        let sut = makeSUT()

        let operatorInfoBookingURL = sut.charger.operatorInfo?.bookingURL
        
        XCTAssertEqual(sut.charger.operatorInfo?.bookingURL, operatorInfoBookingURL)
    }
    
    //MARK: addressInfo

    func test_addressTitle_returnResult() {
        let sut = makeSUT()

        let addressTitle = sut.charger.addressInfo?.title
        
        XCTAssertEqual(sut.charger.addressInfo?.title, addressTitle)
    }
    
    
    func test_addressLine_returnResult() {
        let sut = makeSUT()

        let addressLine = sut.charger.addressInfo?.addressLine1
        
        XCTAssertEqual(sut.charger.addressInfo?.addressLine1, addressLine)
    }
    
    func test_addressTown_returnResult() {
        let sut = makeSUT()

        let addressTown = sut.charger.addressInfo?.town
        
        XCTAssertEqual(sut.charger.addressInfo?.town, addressTown)
    }
    
    func test_postcode_returnResult() {
        let sut = makeSUT()

        let postcode = sut.charger.addressInfo?.postcode
        
        XCTAssertEqual(sut.charger.addressInfo?.postcode, postcode)
    }

    func test_distance_returnResult() {
        let sut = makeSUT()

        let distance = sut.charger.addressInfo?.distance
        
        XCTAssertEqual(sut.charger.addressInfo?.distance, distance)
    }
    
    func test_coordinate_returnResult() {
        let sut = makeSUT()

        let latitude = sut.charger.addressInfo?.latitude
        let longitude = sut.charger.addressInfo?.longitude
        
        XCTAssertEqual(sut.charger.addressInfo?.latitude, latitude)
        XCTAssertEqual(sut.charger.addressInfo?.longitude, longitude)
    }
    
    //MARK: Helper
    
    private func makeSUT() -> ChargerViewModel {
        let charger = uniqueCharger()
        let sut = ChargerViewModel(charger: charger)

        return sut
    }
    
    private func uniqueCharger() -> Charger {
        return Charger(dataProvider: nil, operatorInfo: OperatorInfo(websiteURL: "http://a-url.com", comments: "any comment", phonePrimaryContact: "0123456789", phoneSecondaryContact: "0123456789", isPrivateIndividual: nil, addressInfo: nil, bookingURL: nil, contactEmail: nil, faultReportEmail: nil, isRestrictedEdit: nil, id: nil, title: "any title"), usageType: nil, statusType: nil, submissionStatus: nil, userComments: nil, percentageSimilarity: nil, mediaItems: nil, isRecentlyVerified: nil, dateLastVerified: nil, id: nil, uuid: UUID().uuidString, parentChargePointID: nil, dataProviderID: nil, dataProvidersReference: nil, operatorID: nil, operatorsReference: nil, usageTypeID: nil, usageCost: nil, addressInfo: AddressInfo(id: nil, title: "any address title", addressLine1: "any address line", addressLine2: nil, town: "any town", stateOrProvince: "any state", postcode: "any postcode", countryID: nil, country: nil, latitude: 0.0, longitude: 0.0, contactTelephone1: "0123456789", contactTelephone2: nil, contactEmail: nil, accessComments: nil, relatedURL: nil, distance: 0.1, distanceUnit: nil), connections: nil, numberOfPoints: nil, generalComments: nil, datePlanned: nil, dateLastConfirmed: nil, statusTypeID: nil, dateLastStatusUpdate: Date(), dataQualityLevel: nil, dateCreated: Date(), submissionStatusTypeID: nil)
    }
}
