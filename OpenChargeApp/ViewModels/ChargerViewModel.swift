//
//  ChargerViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 24/02/2022.
//

import Foundation

class ChargerViewModel: ObservableObject {
    let charger: Charger
    
    init(charger: Charger) {
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
    
    //MARK: connectionType
    
    func connectionType() -> String {
        guard let connectionType = charger.connections?.first?.connectionType?.title else {
            return ""
        }
        return connectionType
    }
    
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
    
    func levelTitle() -> String {
        guard let levelTitle = charger.connections?.first?.level?.title else {
            return "Unknown"
        }
        return levelTitle
    }
    
    func levelComments() -> String {
        guard let levelComments = charger.connections?.first?.level?.comments else {
            return ""
        }
        return levelComments
    }
    
    func amps() -> String {
        guard let amps = charger.connections?.first?.amps else {
            return ""
        }
        return "\(amps) amps"
    }
    
    func voltage() -> String {
        guard let voltage = charger.connections?.first?.voltage else {
            return ""
        }
        return "\(voltage) V"
    }
    
    func powerKW() -> String {
        guard let powerKW = charger.connections?.first?.powerKW else {
            return ""
        }
        return "\(powerKW) kW"
    }
        
    func currentTypeTitle() -> String {
        guard let currentTypeTitle = charger.connections?.first?.currentType?.title else {
            return ""
        }
        return currentTypeTitle
    }
    
    func quantity() -> String {
        guard let quantity = charger.connections?.first?.quantity else {
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
            return ""
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
