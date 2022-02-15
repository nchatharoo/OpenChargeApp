//
//  Item.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation

public typealias Charge = [ChargePoint]

// MARK: - ItemElement
public struct ChargePoint: Codable, Equatable, Identifiable {
    public static func == (lhs: ChargePoint, rhs: ChargePoint) -> Bool {
        lhs.id == rhs.id
    }
    let isRecentlyVerified: Bool?
    public let id: Int?
    let uuid: String?
    let dataProviderID, usageTypeID: Int?
    let usageCost: String?
    let addressInfo: AddressInfo?
    let connections: [Connection]?
    let numberOfPoints: Int?
    let generalComments: String?
    let dateLastConfirmed: Date?
    let statusTypeID: Int?
    let dateLastStatusUpdate: Date?
    let dataQualityLevel: Int?
    let dateCreated: Date?
    let submissionStatusTypeID, operatorID: Int?
    let operatorsReference, dataProvidersReference: String?

    enum CodingKeys: String, CodingKey {
        case isRecentlyVerified = "IsRecentlyVerified"
        case id = "ID"
        case uuid = "UUID"
        case dataProviderID = "DataProviderID"
        case usageTypeID = "UsageTypeID"
        case usageCost = "UsageCost"
        case addressInfo = "AddressInfo"
        case connections = "Connections"
        case numberOfPoints = "NumberOfPoints"
        case generalComments = "GeneralComments"
        case dateLastConfirmed = "DateLastConfirmed"
        case statusTypeID = "StatusTypeID"
        case dateLastStatusUpdate = "DateLastStatusUpdate"
        case dataQualityLevel = "DataQualityLevel"
        case dateCreated = "DateCreated"
        case submissionStatusTypeID = "SubmissionStatusTypeID"
        case operatorID = "OperatorID"
        case operatorsReference = "OperatorsReference"
        case dataProvidersReference = "DataProvidersReference"
    }
}

// MARK: - AddressInfo
struct AddressInfo: Codable {
    let id: Int?
    let title, addressLine1, addressLine2, town: String?
    let stateOrProvince, postcode: String?
    let countryID: Int?
    let latitude, longitude: Double?
    let contactTelephone1, contactTelephone2: String?
    let contactEmail: String?
    let accessComments: String?
    let distance: Double?
    let distanceUnit: Int?
    let relatedURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case town = "Town"
        case stateOrProvince = "StateOrProvince"
        case postcode = "Postcode"
        case countryID = "CountryID"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case contactTelephone1 = "ContactTelephone1"
        case contactTelephone2 = "ContactTelephone2"
        case contactEmail = "ContactEmail"
        case accessComments = "AccessComments"
        case distance = "Distance"
        case distanceUnit = "DistanceUnit"
        case relatedURL = "RelatedURL"
    }
}

// MARK: - Connection
struct Connection: Codable {
    let id, connectionTypeID, statusTypeID, amps: Int?
    let quantity, levelID, powerKW, currentTypeID: Decimal?
    let voltage: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case connectionTypeID = "ConnectionTypeID"
        case statusTypeID = "StatusTypeID"
        case amps = "Amps"
        case quantity = "Quantity"
        case levelID = "LevelID"
        case powerKW = "PowerKW"
        case currentTypeID = "CurrentTypeID"
        case voltage = "Voltage"
    }
}

