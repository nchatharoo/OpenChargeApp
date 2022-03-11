//
//  Item.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation

public typealias Charge = [Charger]

// MARK: - ChargePoint
public struct Charger: Codable, Equatable, Identifiable {
    public init(dataProvider: DataProvider?, operatorInfo: OperatorInfo?, usageType: UsageType?, statusType: StatusType?, submissionStatus: SubmissionStatus?, userComments: [UserComment]?, percentageSimilarity: Double?, mediaItems: [MediaItem]?, isRecentlyVerified: Bool?, dateLastVerified: Date?, id: Int?, uuid: String?, parentChargePointID: Int?, dataProviderID: Int?, dataProvidersReference: String?, operatorID: Int?, operatorsReference: String?, usageTypeID: Int?, usageCost: String?, addressInfo: AddressInfo?, connections: [Connection]?, numberOfPoints: Int?, generalComments: String?, datePlanned: String?, dateLastConfirmed: String?, statusTypeID: Int?, dateLastStatusUpdate: Date?, dataQualityLevel: Int?, dateCreated: Date?, submissionStatusTypeID: Int?) {
        self.dataProvider = dataProvider
        self.operatorInfo = operatorInfo
        self.usageType = usageType
        self.statusType = statusType
        self.submissionStatus = submissionStatus
        self.userComments = userComments
        self.percentageSimilarity = percentageSimilarity
        self.mediaItems = mediaItems
        self.isRecentlyVerified = isRecentlyVerified
        self.dateLastVerified = dateLastVerified
        self.id = id
        self.uuid = uuid
        self.parentChargePointID = parentChargePointID
        self.dataProviderID = dataProviderID
        self.dataProvidersReference = dataProvidersReference
        self.operatorID = operatorID
        self.operatorsReference = operatorsReference
        self.usageTypeID = usageTypeID
        self.usageCost = usageCost
        self.addressInfo = addressInfo
        self.connections = connections
        self.numberOfPoints = numberOfPoints
        self.generalComments = generalComments
        self.datePlanned = datePlanned
        self.dateLastConfirmed = dateLastConfirmed
        self.statusTypeID = statusTypeID
        self.dateLastStatusUpdate = dateLastStatusUpdate
        self.dataQualityLevel = dataQualityLevel
        self.dateCreated = dateCreated
        self.submissionStatusTypeID = submissionStatusTypeID
    }    
    
    public static func == (lhs: Charger, rhs: Charger) -> Bool {
        lhs.id == rhs.id
    }
    
    let dataProvider: DataProvider?
    let operatorInfo: OperatorInfo?
    let usageType: UsageType?
    let statusType: StatusType?
    let submissionStatus: SubmissionStatus?
    let userComments: [UserComment]?
    let percentageSimilarity: Double?
    let mediaItems: [MediaItem]?
    let isRecentlyVerified: Bool?
    let dateLastVerified: Date?
    public let id: Int?
    let uuid: String?
    let parentChargePointID: Int?
    let dataProviderID: Int?
    let dataProvidersReference: String?
    let operatorID: Int?
    let operatorsReference: String?
    let usageTypeID: Int?
    let usageCost: String?
    let addressInfo: AddressInfo?
    let connections: [Connection]?
    let numberOfPoints: Int?
    let generalComments, datePlanned, dateLastConfirmed: String?
    let statusTypeID: Int?
    let dateLastStatusUpdate: Date?
//    let metadataValues: JSONNull?
    let dataQualityLevel: Int?
    let dateCreated: Date?
    let submissionStatusTypeID: Int?

    enum CodingKeys: String, CodingKey {
        case dataProvider = "DataProvider"
        case operatorInfo = "OperatorInfo"
        case usageType = "UsageType"
        case statusType = "StatusType"
        case submissionStatus = "SubmissionStatus"
        case userComments = "UserComments"
        case percentageSimilarity = "PercentageSimilarity"
        case mediaItems = "MediaItems"
        case isRecentlyVerified = "IsRecentlyVerified"
        case dateLastVerified = "DateLastVerified"
        case id = "ID"
        case uuid = "UUID"
        case parentChargePointID = "ParentChargePointID"
        case dataProviderID = "DataProviderID"
        case dataProvidersReference = "DataProvidersReference"
        case operatorID = "OperatorID"
        case operatorsReference = "OperatorsReference"
        case usageTypeID = "UsageTypeID"
        case usageCost = "UsageCost"
        case addressInfo = "AddressInfo"
        case connections = "Connections"
        case numberOfPoints = "NumberOfPoints"
        case generalComments = "GeneralComments"
        case datePlanned = "DatePlanned"
        case dateLastConfirmed = "DateLastConfirmed"
        case statusTypeID = "StatusTypeID"
        case dateLastStatusUpdate = "DateLastStatusUpdate"
//        case metadataValues = "MetadataValues"
        case dataQualityLevel = "DataQualityLevel"
        case dateCreated = "DateCreated"
        case submissionStatusTypeID = "SubmissionStatusTypeID"
    }
}

// MARK: - AddressInfo
public struct AddressInfo: Codable {
    let id: Int?
    let title, addressLine1: String?
    let addressLine2: String?
    let town, stateOrProvince: String?
    let postcode: String?
    let countryID: Int?
    let country: Country?
    let latitude, longitude: Double?
    let contactTelephone1, contactTelephone2, contactEmail, accessComments: String?
    let relatedURL: String?
    let distance: Double?
    let distanceUnit: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case addressLine1 = "AddressLine1"
        case addressLine2 = "AddressLine2"
        case town = "Town"
        case stateOrProvince = "StateOrProvince"
        case postcode = "Postcode"
        case countryID = "CountryID"
        case country = "Country"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case contactTelephone1 = "ContactTelephone1"
        case contactTelephone2 = "ContactTelephone2"
        case contactEmail = "ContactEmail"
        case accessComments = "AccessComments"
        case relatedURL = "RelatedURL"
        case distance = "Distance"
        case distanceUnit = "DistanceUnit"
    }
}

// MARK: - Country
struct Country: Codable {
    let isoCode: String?
    let continentCode: String?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case isoCode = "ISOCode"
        case continentCode = "ContinentCode"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - Connection
public struct Connection: Codable {
    let id, connectionTypeID: Int?
    let connectionType: ConnectionType?
    let reference: String?
    let statusTypeID: Int?
    let statusType: StatusType?
    let levelID: Int?
    let level: Level?
    let amps, voltage: Int?
    let powerKW: Double?
    let currentTypeID: Int?
    let currentType: CurrentType?
    let quantity: Int?
    let comments: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case connectionTypeID = "ConnectionTypeID"
        case connectionType = "ConnectionType"
        case reference = "Reference"
        case statusTypeID = "StatusTypeID"
        case statusType = "StatusType"
        case levelID = "LevelID"
        case level = "Level"
        case amps = "Amps"
        case voltage = "Voltage"
        case powerKW = "PowerKW"
        case currentTypeID = "CurrentTypeID"
        case currentType = "CurrentType"
        case quantity = "Quantity"
        case comments = "Comments"
    }
}

// MARK: - ConnectionType
struct ConnectionType: Codable {
    let formalName: String?
    let isDiscontinued, isObsolete: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case formalName = "FormalName"
        case isDiscontinued = "IsDiscontinued"
        case isObsolete = "IsObsolete"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - CurrentType
struct CurrentType: Codable {
    let currentTypeDescription: String?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case currentTypeDescription = "Description"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - Level
struct Level: Codable {
    let comments: String?
    let isFastChargeCapable: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case comments = "Comments"
        case isFastChargeCapable = "IsFastChargeCapable"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - StatusType
public struct StatusType: Codable {
    let isOperational, isUserSelectable: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case isOperational = "IsOperational"
        case isUserSelectable = "IsUserSelectable"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - DataProvider
public struct DataProvider: Codable {
    let websiteURL: String?
    let comments: String?
    let dataProviderStatusType: DataProviderStatusType?
    let isRestrictedEdit, isOpenDataLicensed, isApprovedImport: Bool?
    let license: String?
    let dateLastImported: String?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case websiteURL = "WebsiteURL"
        case comments = "Comments"
        case dataProviderStatusType = "DataProviderStatusType"
        case isRestrictedEdit = "IsRestrictedEdit"
        case isOpenDataLicensed = "IsOpenDataLicensed"
        case isApprovedImport = "IsApprovedImport"
        case license = "License"
        case dateLastImported = "DateLastImported"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - DataProviderStatusType
public struct DataProviderStatusType: Codable {
    let isProviderEnabled: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case isProviderEnabled = "IsProviderEnabled"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - MediaItem
public struct MediaItem: Codable {
    let id, chargePointID: Int?
    let itemURL, itemThumbnailURL: String?
    let comment: String?
    let isEnabled, isVideo, isFeaturedItem, isExternalResource: Bool?
//    let metadataValue: JSONNull?
    let user: User?
    let dateCreated: Date?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case chargePointID = "ChargePointID"
        case itemURL = "ItemURL"
        case itemThumbnailURL = "ItemThumbnailURL"
        case comment = "Comment"
        case isEnabled = "IsEnabled"
        case isVideo = "IsVideo"
        case isFeaturedItem = "IsFeaturedItem"
        case isExternalResource = "IsExternalResource"
//        case metadataValue = "MetadataValue"
        case user = "User"
        case dateCreated = "DateCreated"
    }
}

// MARK: - User
public struct User: Codable {
    let id: Int?
    let identityProvider, identifier, currentSessionToken: String?
    let username: String?
    let profile, location, websiteURL: String?
    let reputationPoints: Int?
    let permissions, permissionsRequested, dateCreated, dateLastLogin: String?
    let isProfilePublic, isEmergencyChargingProvider, isPublicChargingProvider : Bool?
    let latitude: Double?
    let longitude: Double?
    let emailAddress, emailHash: String?
    let profileImageURL: String?
    let isCurrentSessionTokenValid, apiKey, syncedSettings: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case identityProvider = "IdentityProvider"
        case identifier = "Identifier"
        case currentSessionToken = "CurrentSessionToken"
        case username = "Username"
        case profile = "Profile"
        case location = "Location"
        case websiteURL = "WebsiteURL"
        case reputationPoints = "ReputationPoints"
        case permissions = "Permissions"
        case permissionsRequested = "PermissionsRequested"
        case dateCreated = "DateCreated"
        case dateLastLogin = "DateLastLogin"
        case isProfilePublic = "IsProfilePublic"
        case isEmergencyChargingProvider = "IsEmergencyChargingProvider"
        case isPublicChargingProvider = "IsPublicChargingProvider"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case emailAddress = "EmailAddress"
        case emailHash = "EmailHash"
        case profileImageURL = "ProfileImageURL"
        case isCurrentSessionTokenValid = "IsCurrentSessionTokenValid"
        case apiKey = "APIKey"
        case syncedSettings = "SyncedSettings"
    }
}

// MARK: - OperatorInfo
public struct OperatorInfo: Codable {
    let websiteURL: String?
    let comments: String?
    let phonePrimaryContact: String?
    let phoneSecondaryContact: String?
    let isPrivateIndividual: Bool?
    let addressInfo, bookingURL, contactEmail, faultReportEmail: String?
    let isRestrictedEdit: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case websiteURL = "WebsiteURL"
        case comments = "Comments"
        case phonePrimaryContact = "PhonePrimaryContact"
        case phoneSecondaryContact = "PhoneSecondaryContact"
        case isPrivateIndividual = "IsPrivateIndividual"
        case addressInfo = "AddressInfo"
        case bookingURL = "BookingURL"
        case contactEmail = "ContactEmail"
        case faultReportEmail = "FaultReportEmail"
        case isRestrictedEdit = "IsRestrictedEdit"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - SubmissionStatus
public struct SubmissionStatus: Codable {
    let isLive: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case isLive = "IsLive"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - UsageType
public struct UsageType: Codable {
    let isPayAtLocation, isMembershipRequired, isAccessKeyRequired: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case isPayAtLocation = "IsPayAtLocation"
        case isMembershipRequired = "IsMembershipRequired"
        case isAccessKeyRequired = "IsAccessKeyRequired"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - UserComment
public struct UserComment: Codable {
    let id, chargePointID, commentTypeID: Int?
    let commentType: CommentType?
    let userName, comment: String?
    let rating: Int?
    let relatedURL: String?
    let dateCreated: String?
    let user: User?
    let checkinStatusTypeID: Int?
    let checkinStatusType: CheckinStatusType?
    let isActionedByEditor: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case chargePointID = "ChargePointID"
        case commentTypeID = "CommentTypeID"
        case commentType = "CommentType"
        case userName = "UserName"
        case comment = "Comment"
        case rating = "Rating"
        case relatedURL = "RelatedURL"
        case dateCreated = "DateCreated"
        case user = "User"
        case checkinStatusTypeID = "CheckinStatusTypeID"
        case checkinStatusType = "CheckinStatusType"
        case isActionedByEditor = "IsActionedByEditor"
    }
}

// MARK: - CheckinStatusType
public struct CheckinStatusType: Codable {
    let isPositive, isAutomatedCheckin: Bool?
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case isPositive = "IsPositive"
        case isAutomatedCheckin = "IsAutomatedCheckin"
        case id = "ID"
        case title = "Title"
    }
}

// MARK: - CommentType
public struct CommentType: Codable {
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
    }
}
