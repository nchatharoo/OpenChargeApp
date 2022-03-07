//
//  OpenChargeViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/01/2022.
//

import Foundation
import MapKit
import Combine
import SwiftUI

struct NetworkError: Error, Identifiable {
    let id = UUID()
    let title = "Error"
    var message = ""
}

final public class ChargersViewModel: ObservableObject {
    let client: HTTPClient
    private let baseAPIURL = URL(string: "https://api.openchargemap.io/v3/poi/")!
    public var cancellables: AnyCancellable? = nil
    @Published private var chargePoints = Charge()
    @Published public var filteredChargePoints = Charge()

    @Published var isProcessing = false
    @Published var query = ""
    @Published var networkError: NetworkError?
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
    private lazy var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadChargePoints(with coordinate: CLLocationCoordinate2D) {
        isProcessing = true
        
        cancellables = client.getPublisher(from: baseAPIURL, with: coordinate)
            .tryMap { (data: Data, response: HTTPURLResponse) in
                data
            }
            .decode(type: Charge.self, decoder: jsonDecoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.networkError = NetworkError(message: "Details: \(error.localizedDescription)")
                }
                self.isProcessing = false
            }, receiveValue: { [weak self] chargePoints in
                guard let self = self else { return }
                self.chargePoints = chargePoints
                self.filteredChargePoints = chargePoints
            })
    }
    
    //MARK: filter
    /*
     
     StatusType :
     isOperational
     isUserSelectable
    */
    
    func filterCharger(with filters: ChargerFilter) {
        _ = $chargePoints
            .map { charger in
                var filtered = charger.filter({ filters.powerKW == 0 || $0.connections?.first?.powerKW ?? 0.0 < filters.powerKW })
                
                switch filters.usageType {
                case .isPayAtLocation: filtered.removeAll(where: { $0.usageType?.isPayAtLocation ?? false })
                case .isMembershipRequired: filtered.removeAll(where: { $0.usageType?.isMembershipRequired ?? false })
                case .isAccessKeyRequired: filtered.removeAll(where: { $0.usageType?.isAccessKeyRequired ?? false })
                case .all: break
                }
                
                filtered.removeAll(where: { $0.connections?.first?.connectionType?.title == filters.connectionType[filters.connectionIndex]
                })
                                
                if filters.showIsOperational {
                    filtered.removeAll(where: { $0.statusType?.isOperational ?? false })
                }
                
                return filtered
            }
            .sink(receiveValue: { charger in
                self.filteredChargePoints = charger
            })
    }
}

struct ChargerFilter: Equatable {
    var usageType: ChargerUsage = .all
    var powerKW: Double = 0.0
    var showIsOperational: Bool = false
    var connectionIndex: Int = 0
    var connectionType = [
        "Avcon Connector",
        "BS1363 3 Pin 13 Amp",
        "Blue Commando (2P+E)",
        "CCS (Type 1)",
        "CCS (Type 2)",
        "CEE 3 Pin",
        "CEE 5 Pin",
        "CEE 7/4 - Schuko - Type F",
        "CEE 7/5",
        "CEE+ 7 Pin",
        "CHAdeMO",
        "Europlug 2-Pin (CEE 7/16)",
        "GB-T AC - GB/T 20234.2 (Socket)",
        "GB-T AC - GB/T 20234.2 (Tethered Cable)",
        "GB-T DC - GB/T 20234.3",
        "IEC 60309 3-pin",
        "IEC 60309 5-pin",
        "LP Inductive",
        "NEMA 14-30",
        "NEMA 14-50",
        "NEMA 5-15R",
        "NEMA 5-20R",
        "NEMA 6-15",
        "NEMA 6-20",
        "NEMA TT-30R",
        "SCAME Type 3A (Low Power)",
        "SCAME Type 3C (Schneider-Legrand)",
        "SP Inductive",
        "T13 - SEC1011 ( Swiss domestic 3-pin ) - Type J",
        "Tesla (Model S/X)",
        "Tesla (Roadster)",
        "Tesla Battery Swap",
        "Tesla Supercharger",
        "Three Phase 5-Pin (AS/NZ 3123)",
        "Type 1 (J1772)",
        "Type 2 (Socket Only)",
        "Type 2 (Tethered Connector)",
        "Type I (AS 3112)",
        "(Unknown)",
        "Wireless Charging",
        "XLR Plug (4 pin)",
    ]
}

enum ChargerUsage: String {
    case all
    case isPayAtLocation
    case isMembershipRequired
    case isAccessKeyRequired
}
