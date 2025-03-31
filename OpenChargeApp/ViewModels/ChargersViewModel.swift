//
//  OpenChargeViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/01/2022.
//  Updated to latest Swift on 31/03/2025
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

@MainActor
final public class ChargersViewModel: ObservableObject {
    let client: HTTPClient
    private let baseAPIURL = URL(string: "https://api.openchargemap.io/v3/poi/")!
    public var cancellables = Set<AnyCancellable>()
    @Published private var chargePoints = Charge()
    @Published public var filteredChargePoints = Charge()

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
    
    // Legacy method using Combine
    public func loadChargePoints(with coordinate: CLLocationCoordinate2D) {
        isProcessing = true
        
        client.getPublisher(from: baseAPIURL, with: coordinate)
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
            .store(in: &cancellables)
    }
    
    // Modern async/await method
    public func loadChargePointsAsync(with coordinate: CLLocationCoordinate2D) async {
        isProcessing = true
        
        do {
            let (data, _) = try await client.get(from: baseAPIURL, with: coordinate)
            let decodedChargePoints = try jsonDecoder.decode(Charge.self, from: data)
            
            self.chargePoints = decodedChargePoints
            self.filteredChargePoints = decodedChargePoints
            self.isProcessing = false
        } catch {
            self.networkError = NetworkError(message: "Details: \(error.localizedDescription)")
            self.isProcessing = false
        }
    }
    
    func filterCharger(with filters: ChargerFilter) {
        $chargePoints
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
            .sink(receiveValue: { [weak self] charger in
                guard let self = self else { return }
                self.filteredChargePoints = charger
            })
            .store(in: &cancellables)
    }
    
    // Helper method for testing
    func getChargePoints() -> Charge {
        return chargePoints
    }
}
