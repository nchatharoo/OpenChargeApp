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
    
    func test_operatorInfoTitle() {
        let sut = makeSUT()

        let operatorInfoTitle = "any title"
        
        XCTAssertEqual(sut.charger.operatorInfo?.title, operatorInfoTitle)
    }
    
    func test_operatorInfoEmail() {
        let sut = makeSUT()

        let operatorInfoEmail: String? = nil
        
        XCTAssertEqual(sut.charger.operatorInfo?.contactEmail, operatorInfoEmail)
    }
    
    func test_operatorInfoPrimaryPhone() {
        let sut = makeSUT()

        let operatorInfoPrimaryPhone = "0123456789"
        
        XCTAssertEqual(sut.charger.operatorInfo?.phonePrimaryContact, operatorInfoPrimaryPhone)
    }
    
    func test_operatorInfoBookingURL() {
        let sut = makeSUT()

        let operatorInfoBookingURL: String? = nil
        
        XCTAssertEqual(sut.charger.operatorInfo?.bookingURL, operatorInfoBookingURL)
    }
    
    //MARK: addressInfo

    func test_addressTitle() {
        let sut = makeSUT()

        let addressTitle = "any address title"
        
        XCTAssertEqual(sut.charger.addressInfo?.title, addressTitle)
    }
    
    
    func test_addressLine() {
        let sut = makeSUT()

        let addressLine = "any address line"
        
        XCTAssertEqual(sut.charger.addressInfo?.addressLine1, addressLine)
    }
    
    func test_addressTown() {
        let sut = makeSUT()

        let addressTown = "any town"
        
        XCTAssertEqual(sut.charger.addressInfo?.town, addressTown)
    }
    
    func test_postcode() {
        let sut = makeSUT()

        let postcode = "any postcode"
        
        XCTAssertEqual(sut.charger.addressInfo?.postcode, postcode)
    }

    func test_distance() {
        let sut = makeSUT()

        let distance = 0.1
        
        XCTAssertEqual(sut.charger.addressInfo?.distance, distance)
    }
    
    func test_coordinate() {
        let sut = makeSUT()

        let latitude = 0.0
        let longitude = 0.0
        
        XCTAssertEqual(sut.charger.addressInfo?.latitude, latitude)
        XCTAssertEqual(sut.charger.addressInfo?.longitude, longitude)
    }
    
    //MARK: connectionType
    
    func test_connectionType() {
        let sut = makeSUT()

        let connectionType = "a connection title"
        
        XCTAssertEqual(sut.charger.connections?.first?.connectionType?.title, connectionType)
    }
    
    //MARK: statusType
    
    func test_statusTitle() {
        let sut = makeSUT()

        let statusType = "a status title"
        
        XCTAssertEqual(sut.charger.connections?.first?.statusType?.title, statusType)
    }
    
    func test_statusIsOperational() {
        let sut = makeSUT()

        let statusIsOperational = true
        
        XCTAssertEqual(sut.charger.connections?.first?.statusType?.isOperational, statusIsOperational)
    }
    
    //MARK: level

    func test_levelTitle() {
        let sut = makeSUT()

        let levelTitle = "a level title"
        
        XCTAssertEqual(sut.charger.connections?.first?.level?.title, levelTitle)
    }
    
    func test_levelComments() {
        let sut = makeSUT()

        let levelComments: String? = "a level comment"
            
        XCTAssertEqual(sut.charger.connections?.first?.level?.comments, levelComments)
    }
    
    //MARK: connections power
    
    func test_amps() {
        let sut = makeSUT()

        let amps = 10
            
        XCTAssertEqual(sut.charger.connections?.first?.amps, amps)
    }
    
    func test_voltage() {
        let sut = makeSUT()

        let voltage = 10
        
        XCTAssertEqual(sut.charger.connections?.first?.voltage, voltage)
    }
    
    func test_powerKW() {
        let sut = makeSUT()

        let powerKW = 10.0
        
        XCTAssertEqual(sut.charger.connections?.first?.powerKW, powerKW)
    }
    
    //MARK: currentType
        
    func test_currentTypeTitle() {
        let sut = makeSUT()

        let currentTypeTitle = "a current type title"
        
        XCTAssertEqual(sut.charger.connections?.first?.currentType?.title, currentTypeTitle)
    }
    
    //MARK: quantity

    func test_quantity() {
        let sut = makeSUT()

        let quantity = 2
            
        XCTAssertEqual(sut.charger.connections?.first?.quantity, quantity)
    }

    //MARK: Charger info
    
    func test_numberOfPoints() {
        let sut = makeSUT()

        let numberOfPoints: Int? = nil
                
        XCTAssertEqual(sut.charger.numberOfPoints, numberOfPoints)
    }
    
    //MARK: Usage type
    
    func test_usageTypeTitle() {
        let sut = makeSUT()

        let usageTypeTitle = "a usage type title"
        
        XCTAssertEqual(sut.charger.usageType?.title, usageTypeTitle)
    }
    
    func test_isPayAtLocation() {
        let sut = makeSUT()

        let isPayAtLocation = true
        
        XCTAssertEqual(sut.charger.usageType?.isPayAtLocation, isPayAtLocation)
    }
    
    func test_isMembershipRequired() {
        let sut = makeSUT()

        let isMembershipRequired = false
        
        XCTAssertEqual(sut.charger.usageType?.isMembershipRequired, isMembershipRequired)
    }
    
    func test_isAccessKeyRequired() {
        let sut = makeSUT()

        let isAccessKeyRequired = true
        
        XCTAssertEqual(sut.charger.usageType?.isAccessKeyRequired, isAccessKeyRequired)
    }
    
    //MARK: MediaItem
    
    func test_itemThumbnailURL() {
        let sut = makeSUT()

        let itemThumbnailURL: String? = nil
        
        XCTAssertEqual(sut.charger.mediaItems?.first?.itemThumbnailURL, itemThumbnailURL)
    }
    
    //MARK: UsageCost
    
    func test_usageCost() {
        let sut = makeSUT()

        let usageCost = "a usage cost"
        
        XCTAssertEqual(sut.charger.usageCost, usageCost)
    }

    
    //MARK: Helper
    
    private func makeSUT() -> ChargerViewModel {
        let charger = uniqueCharger()
        let sut = ChargerViewModel(charger: charger)

        return sut
    }
    
    private func uniqueCharger() -> Charger {
        return Charger(dataProvider: nil,
                       operatorInfo: OperatorInfo(websiteURL: "http://a-url.com", comments: "any comment", phonePrimaryContact: "0123456789", phoneSecondaryContact: "0123456789", isPrivateIndividual: nil, addressInfo: nil, bookingURL: nil, contactEmail: nil, faultReportEmail: nil, isRestrictedEdit: nil, id: nil, title: "any title"),
                       usageType: UsageType(isPayAtLocation: true,
                                            isMembershipRequired: false,
                                            isAccessKeyRequired: true,
                                            id: nil,
                                            title: "a usage type title"),
                       statusType: nil,
                       submissionStatus: nil,
                       userComments: nil,
                       percentageSimilarity: nil,
                       mediaItems: nil,
                       isRecentlyVerified: nil,
                       dateLastVerified: nil,
                       id: nil,
                       uuid: UUID().uuidString,
                       parentChargePointID: nil,
                       dataProviderID: nil,
                       dataProvidersReference: nil,
                       operatorID: nil,
                       operatorsReference: nil,
                       usageTypeID: nil,
                       usageCost: "a usage cost",
                       addressInfo: AddressInfo(id: nil, title: "any address title", addressLine1: "any address line", addressLine2: nil, town: "any town", stateOrProvince: "any state", postcode: "any postcode", countryID: nil, country: nil, latitude: 0.0, longitude: 0.0, contactTelephone1: "0123456789", contactTelephone2: nil, contactEmail: nil, accessComments: nil, relatedURL: nil, distance: 0.1, distanceUnit: nil),
                       connections: [Connection(id: nil, connectionTypeID: nil, connectionType: ConnectionType(formalName: "a formalName", isDiscontinued: nil, isObsolete: nil, id: nil, title: "a connection title"), reference: nil, statusTypeID: nil, statusType: StatusType(isOperational: true, isUserSelectable: true, id: nil, title: "a status title"), levelID: nil, level: Level(comments: "a level comment", isFastChargeCapable: true, id: nil, title: "a level title"), amps: 10, voltage: 10, powerKW: 10.0, currentTypeID: nil, currentType: CurrentType(currentTypeDescription: "a current type description", id: nil, title: "a current type title"), quantity: 2, comments: "a current type comment")],
                       numberOfPoints: nil,
                       generalComments: nil,
                       datePlanned: nil,
                       dateLastConfirmed: nil,
                       statusTypeID: nil,
                       dateLastStatusUpdate: Date(),
                       dataQualityLevel: nil,
                       dateCreated: Date(),
                       submissionStatusTypeID: nil)
    }
}
