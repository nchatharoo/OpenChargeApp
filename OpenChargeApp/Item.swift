//
//  Item.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation

public typealias Item = [ItemElement]

// MARK: - ItemElement
public struct ItemElement: Codable, Equatable {
    
    public static func == (lhs: ItemElement, rhs: ItemElement) -> Bool {
        lhs.id == rhs.id
    }
    
    let isRecentlyVerified: Bool
    let id: Int
    let uuid: String
    let dataProviderID, operatorID: Int
    let operatorsReference: String?
    let usageTypeID: Int
    let addressInfo: AddressInfo
    let connections: [Connection]
    let numberOfPoints: Int?
    let generalComments: String?
    let statusTypeID: Int
    let dateLastStatusUpdate: Date
    let dataQualityLevel: Int
    let dateCreated: Date
    let submissionStatusTypeID: Int
    let dataProvidersReference, usageCost: String?

    enum CodingKeys: String, CodingKey {
        case isRecentlyVerified = "IsRecentlyVerified"
        case id = "ID"
        case uuid = "UUID"
        case dataProviderID = "DataProviderID"
        case operatorID = "OperatorID"
        case operatorsReference = "OperatorsReference"
        case usageTypeID = "UsageTypeID"
        case addressInfo = "AddressInfo"
        case connections = "Connections"
        case numberOfPoints = "NumberOfPoints"
        case generalComments = "GeneralComments"
        case statusTypeID = "StatusTypeID"
        case dateLastStatusUpdate = "DateLastStatusUpdate"
        case dataQualityLevel = "DataQualityLevel"
        case dateCreated = "DateCreated"
        case submissionStatusTypeID = "SubmissionStatusTypeID"
        case dataProvidersReference = "DataProvidersReference"
        case usageCost = "UsageCost"
    }
}

// MARK: - AddressInfo
public struct AddressInfo: Codable {
    let id: Int
    let title, addressLine1: String
    let town, postcode: String?
    let countryID: Int
    let latitude, longitude: Double
    let contactTelephone1: String?
    let distance: Double
    let distanceUnit: Int
    let accessComments, stateOrProvince, addressLine2, contactTelephone2: String?
    let contactEmail: String?
    let relatedURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case addressLine1 = "AddressLine1"
        case town = "Town"
        case postcode = "Postcode"
        case countryID = "CountryID"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case contactTelephone1 = "ContactTelephone1"
        case distance = "Distance"
        case distanceUnit = "DistanceUnit"
        case accessComments = "AccessComments"
        case stateOrProvince = "StateOrProvince"
        case addressLine2 = "AddressLine2"
        case contactTelephone2 = "ContactTelephone2"
        case contactEmail = "ContactEmail"
        case relatedURL = "RelatedURL"
    }
}

// MARK: - Connection
public struct Connection: Codable {
    let id, connectionTypeID, statusTypeID, levelID: Int
    let powerKW, currentTypeID: Int
    let quantity, amps, voltage: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case connectionTypeID = "ConnectionTypeID"
        case statusTypeID = "StatusTypeID"
        case levelID = "LevelID"
        case powerKW = "PowerKW"
        case currentTypeID = "CurrentTypeID"
        case quantity = "Quantity"
        case amps = "Amps"
        case voltage = "Voltage"
    }
}


