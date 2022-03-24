//
//  ChargerViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 24/02/2022.
//

import Foundation
import CoreLocation
import SwiftUI

public class ChargerViewModel: ObservableObject {
    public let charger: Charger

    public init(charger: Charger) {
        self.charger = charger
    }
    
    //MARK : Operator info
    
    func operatorInfoTitle() -> String {
        guard let operatorInfoTitle = charger.operatorInfo?.title else {
            return ""
        }
        return operatorInfoTitle
    }
    
    func operatorInfoEmail() -> URL? {
        guard let operatorInfoEmail = charger.operatorInfo?.contactEmail else {
            return nil
        }
        return URL(string: "mailto:\(operatorInfoEmail)")!
    }
    
    func operatorInfoPrimaryPhone() -> URL? {
        guard let operatorInfoPrimaryPhone = charger.operatorInfo?.phonePrimaryContact else {
            return nil
        }
        return URL(string: "tel:\(operatorInfoPrimaryPhone.replacingOccurrences(of: " ", with: ""))")!
    }
    
    func operatorInfoBookingURL() -> URL? {
        guard let operatorInfoBookingURL = charger.operatorInfo?.bookingURL else {
            return nil
        }
        return URL(string: operatorInfoBookingURL)!
    }

    //MARK: addressInfo

    func addressTitle() -> String {
        guard let addressTitle = charger.addressInfo?.title else {
            return ""
        }
        return addressTitle
    }
    
    func addressLine() -> String {
        guard let addressLine = charger.addressInfo?.addressLine1 else {
            return ""
        }
        return addressLine
    }
    
    func addressTown() -> String {
        guard let addressTown = charger.addressInfo?.town else {
            return ""
        }
        return addressTown
    }
    
    func postcode() -> String {
        guard let postcode = charger.addressInfo?.postcode else {
            return ""
        }
        return postcode
    }

    func distance() -> Double {
        guard let distance = charger.addressInfo?.distance else {
            return 0.0
        }
        return distance
    }
    
    func coordinate() -> CLLocationCoordinate2D {
        guard let latitude = charger.addressInfo?.latitude, let longitude = charger.addressInfo?.longitude else { return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //MARK: connectionType
    
    func connections() -> [Connection] {
        guard let connections = charger.connections else {
            return []
        }
        return connections
    }
    
    func connectionType(_ connection: Connection) -> String {
        guard let connectionType = connection.connectionType?.title else {
            return ""
        }
        return connectionType
    }
    
    //MARK: statusType
    
    func statusTitle() -> String {
        guard let statusType = charger.connections?.first?.statusType?.title else {
            return "Unknown"
        }
        return statusType
    }
    
    func statusIsOperational() -> Bool {
        guard let statusIsOperational = charger.connections?.first?.statusType?.isOperational else {
            return false
        }
        return statusIsOperational
    }
    
    //MARK: level

    func levelTitle(_ connection: Connection) -> String {
        guard let levelTitle = connection.level?.title else {
            return "Unknown"
        }
        return levelTitle
    }
    
    func levelComments(_ connection: Connection) -> String {
        guard let levelComments = connection.level?.comments else {
            return ""
        }
        return levelComments
    }
    
    //MARK: connections power

    func amps(_ connection: Connection) -> String {
        guard let amps = connection.amps else {
            return "-"
        }
        return "\(amps) amps"
    }
    
    func voltage(_ connection: Connection) -> String {
        guard let voltage = connection.voltage else {
            return "-"
        }
        return "\(voltage) V"
    }
    
    func powerKW(_ connection: Connection) -> String {
        guard let powerKW = connection.powerKW else {
            return "-"
        }
        return "\(powerKW) kW"
    }
    
    //MARK: currentType

    func currentTypeTitle(_ connection: Connection) -> String {
        guard let currentTypeTitle = connection.currentType?.title else {
            return ""
        }
        return currentTypeTitle
    }
    
    func connectionTypeImage(_ connection: Connection) -> Image {
        guard let connectionTypeID = connection.connectionTypeID else {
            return Image("Unknown")
        }
        switch connectionTypeID {
        case 1:
            return Image("Type1_J1772")
        case 2:
            return Image("Chademo_type4")
        case 25:
            return Image("Type2_socket")
        case 32:
            return Image("Type1_CCS")
        case 33:
            return Image("Type2_CCS")
        case 1036:
            return Image("Type2_tethered")
        default:
            return Image("Unknown")
        }
    }


    //MARK: quantity
    
    func quantity(_ connection: Connection) -> String {
        guard let quantity = connection.quantity else {
            return ""
        }
        return "\(quantity)"
    }
    
    //MARK: Charger info
    
    func numberOfPoints() -> String {
        guard let numberOfPoints = charger.numberOfPoints else {
            return ""
        }
        return "\(numberOfPoints)"
    }
    
    //MARK: Usage type
    
    func usageTypeTitle() -> String {
        guard let usageTypeTitle = charger.usageType?.title else {
            return "N/A"
        }
        return usageTypeTitle
    }
    
    func isPayAtLocation() -> Bool {
        guard let isPayAtLocation = charger.usageType?.isPayAtLocation else {
            return false
        }
        return isPayAtLocation
    }
    
    func isMembershipRequired() -> Bool {
        guard let isMembershipRequired = charger.usageType?.isMembershipRequired else {
            return false
        }
        return isMembershipRequired
    }
    
    func isAccessKeyRequired() -> Bool {
        guard let isAccessKeyRequired = charger.usageType?.isAccessKeyRequired else {
            return false
        }
        return isAccessKeyRequired
    }
    
    //MARK: MediaItem
    
    func itemThumbnailURL() -> String {
        guard let itemThumbnailURL = charger.mediaItems?.first?.itemThumbnailURL else {
            return ""
        }
        return itemThumbnailURL
    }
    
    //MARK: UsageCost
    
    func usageCost() -> String {
        guard let usageCost = charger.usageCost else {
            return ""
        }
        return usageCost
    }
}
