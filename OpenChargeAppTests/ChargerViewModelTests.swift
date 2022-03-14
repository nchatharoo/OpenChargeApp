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

        let operatorInfoTitle = sut.charger.operatorInfo?.title
        
        XCTAssertEqual(sut.charger.operatorInfo?.title, operatorInfoTitle)
    }
    
    func test_operatorInfoEmail() {
        let sut = makeSUT()

        let operatorInfoEmail = sut.charger.operatorInfo?.contactEmail
        
        XCTAssertEqual(sut.charger.operatorInfo?.contactEmail, operatorInfoEmail)
    }
    
    func test_operatorInfoPrimaryPhone() {
        let sut = makeSUT()

        let operatorInfoPrimaryPhone = sut.charger.operatorInfo?.phonePrimaryContact
        
        XCTAssertEqual(sut.charger.operatorInfo?.phonePrimaryContact, operatorInfoPrimaryPhone)
    }
    
    func test_operatorInfoBookingURL() {
        let sut = makeSUT()

        let operatorInfoBookingURL = sut.charger.operatorInfo?.bookingURL
        
        XCTAssertEqual(sut.charger.operatorInfo?.bookingURL, operatorInfoBookingURL)
    }
    
    //MARK: addressInfo

    func test_addressTitle() {
        let sut = makeSUT()

        let addressTitle = sut.charger.addressInfo?.title
        
        XCTAssertEqual(sut.charger.addressInfo?.title, addressTitle)
    }
    
    
    func test_addressLine() {
        let sut = makeSUT()

        let addressLine = sut.charger.addressInfo?.addressLine1
        
        XCTAssertEqual(sut.charger.addressInfo?.addressLine1, addressLine)
    }
    
    func test_addressTown() {
        let sut = makeSUT()

        let addressTown = sut.charger.addressInfo?.town
        
        XCTAssertEqual(sut.charger.addressInfo?.town, addressTown)
    }
    
    func test_postcode() {
        let sut = makeSUT()

        let postcode = sut.charger.addressInfo?.postcode
        
        XCTAssertEqual(sut.charger.addressInfo?.postcode, postcode)
    }

    func test_distance() {
        let sut = makeSUT()

        let distance = sut.charger.addressInfo?.distance
        
        XCTAssertEqual(sut.charger.addressInfo?.distance, distance)
    }
    
    func test_coordinate() {
        let sut = makeSUT()

        let latitude = sut.charger.addressInfo?.latitude
        let longitude = sut.charger.addressInfo?.longitude
        
        XCTAssertEqual(sut.charger.addressInfo?.latitude, latitude)
        XCTAssertEqual(sut.charger.addressInfo?.longitude, longitude)
    }
    
    //MARK: connectionType
    
    func test_connectionType() {
        let sut = makeSUT()

        let connectionType = sut.charger.connections?.first?.connectionType?.title
        
        XCTAssertEqual(sut.charger.connections?.first?.connectionType?.title, connectionType)
    }
    
    //MARK: statusType
    
    func test_statusTitle() {
        let sut = makeSUT()

        let statusType = sut.charger.connections?.first?.statusType?.title
        
        XCTAssertEqual(sut.charger.connections?.first?.statusType?.title, statusType)
    }
    
    func test_statusIsOperational() {
        let sut = makeSUT()

        let statusIsOperational = sut.charger.connections?.first?.statusType?.isOperational
        
        XCTAssertEqual(sut.charger.connections?.first?.statusType?.isOperational, statusIsOperational)
    }
    
    //MARK: level

    func test_levelTitle() {
        let sut = makeSUT()

        let levelTitle = sut.charger.connections?.first?.level?.title
        
        XCTAssertEqual(sut.charger.connections?.first?.level?.title, levelTitle)
    }
    
    func test_levelComments() {
        let sut = makeSUT()

        let levelComments = sut.charger.connections?.first?.level?.comments
            
        XCTAssertEqual(sut.charger.connections?.first?.level?.comments, levelComments)
    }
    
    //MARK: connections power
    
    func test_amps() {
        let sut = makeSUT()

        let amps = sut.charger.connections?.first?.amps
            
        XCTAssertEqual(sut.charger.connections?.first?.amps, amps)
    }
    
    func test_voltage() {
        let sut = makeSUT()

        let voltage = sut.charger.connections?.first?.voltage
        
        XCTAssertEqual(sut.charger.connections?.first?.voltage, voltage)
    }
    
    func test_powerKW() {
        let sut = makeSUT()

        let powerKW = sut.charger.connections?.first?.powerKW
        
        XCTAssertEqual(sut.charger.connections?.first?.powerKW, powerKW)
    }
    
    //MARK: currentType
        
    func test_currentTypeTitle() {
        let sut = makeSUT()

        let currentTypeTitle = sut.charger.connections?.first?.currentType?.title
        
        XCTAssertEqual(sut.charger.connections?.first?.currentType?.title, currentTypeTitle)
    }
    
    //MARK: quantity

    func test_quantity() {
        let sut = makeSUT()

        let quantity = sut.charger.connections?.first?.quantity
            
        XCTAssertEqual(sut.charger.connections?.first?.quantity, quantity)
    }

    //MARK: Charger info
    
    func test_numberOfPoints() {
        let sut = makeSUT()

        let numberOfPoints = sut.charger.numberOfPoints
                
        XCTAssertEqual(sut.charger.numberOfPoints, numberOfPoints)
    }
    
    //MARK: Usage type
    
    func test_usageTypeTitle() {
        let sut = makeSUT()

        let usageTypeTitle = sut.charger.usageType?.title
        
        XCTAssertEqual(sut.charger.usageType?.title, usageTypeTitle)
    }
    
    func test_isPayAtLocation() {
        let sut = makeSUT()

        let isPayAtLocation = sut.charger.usageType?.isPayAtLocation
        
        XCTAssertEqual(sut.charger.usageType?.isPayAtLocation, isPayAtLocation)
    }
    
    func test_isMembershipRequired() {
        let sut = makeSUT()

        let isMembershipRequired = sut.charger.usageType?.isMembershipRequired
        
        XCTAssertEqual(sut.charger.usageType?.isMembershipRequired, isMembershipRequired)
    }
    
    func test_isAccessKeyRequired() {
        let sut = makeSUT()

        let isAccessKeyRequired = sut.charger.usageType?.isAccessKeyRequired
        
        XCTAssertEqual(sut.charger.usageType?.isAccessKeyRequired, isAccessKeyRequired)
    }
    
    //MARK: MediaItem
    
    func test_itemThumbnailURL() {
        let sut = makeSUT()

        let itemThumbnailURL = sut.charger.mediaItems?.first?.itemThumbnailURL
        
        XCTAssertEqual(sut.charger.mediaItems?.first?.itemThumbnailURL, itemThumbnailURL)
    }
    
    //MARK: UsageCost
    
    func test_usageCost() {
        let sut = makeSUT()

        let usageCost = sut.charger.usageCost
        
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
                       operatorInfo: OperatorInfo(websiteURL: "http://a-url.com", comments: "any comment", phonePrimaryContact: "0123456789", phoneSecondaryContact: "0123456789", isPrivateIndividual: nil, addressInfo: nil, bookingURL: nil, contactEmail: nil, faultReportEmail: nil, isRestrictedEdit: nil, id: nil, title: "any title"), usageType: UsageType(isPayAtLocation: true, isMembershipRequired: false, isAccessKeyRequired: true, id: nil, title: "a usage type title"),
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
                       connections: [Connection(id: nil, connectionTypeID: nil, connectionType: ConnectionType(formalName: "a formalName", isDiscontinued: nil, isObsolete: nil, id: nil, title: "a connection title"), reference: nil, statusTypeID: nil, statusType: StatusType(isOperational: true, isUserSelectable: true, id: nil, title: "a status type"), levelID: nil, level: Level(comments: "a level comment", isFastChargeCapable: true, id: nil, title: "a level title"), amps: 10, voltage: 10, powerKW: 10.0, currentTypeID: nil, currentType: CurrentType(currentTypeDescription: "a current type description", id: nil, title: "a current type title"), quantity: 2, comments: "a current type comment")],
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
