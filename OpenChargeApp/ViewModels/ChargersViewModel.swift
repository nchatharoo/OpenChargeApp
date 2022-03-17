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
    @Published private var chargePoints = Chargers()
    @Published public var filteredChargePoints = Chargers()

    @Published var isProcessing = false
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
    
    public func loadChargers(with coordinate: CLLocationCoordinate2D) {
        isProcessing = true
        
        cancellables = client.getPublisher(from: baseAPIURL, with: coordinate)
            .tryMap { (data: Data, response: HTTPURLResponse) in
                data
            }
            .decode(type: Chargers.self, decoder: jsonDecoder)
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
    
    func filterCharger(with filters: ChargerFiltersViewModel) {
        _ = $chargePoints
            .map { charger in
                var filtered = charger.filter({ filters.powerKW == 0 || $0.connections?.first?.powerKW ?? 0.0 > filters.powerKW })
                
                if filters.isPayAtLocation {
                    filtered.removeAll(where: { $0.usageType?.isPayAtLocation ?? false })
                }
                
                if filters.isMembershipRequired {
                    filtered.removeAll(where: { $0.usageType?.isMembershipRequired ?? false })
                }
                
                if filters.isAccessKeyRequired {
                    filtered.removeAll(where: { $0.usageType?.isAccessKeyRequired ?? false })
                }
                                
                if filters.showIsOperational {
                    filtered.removeAll(where: { $0.statusType?.isOperational ?? false })
                }
                
                filtered.removeAll(where: {
                    $0.connections?.first?.connectionType?.title == filters.connectionType[filters.connectionIndex]
                })
                
                return filtered
            }
            .sink(receiveValue: { charger in
                self.filteredChargePoints = charger
            })
    }
}
