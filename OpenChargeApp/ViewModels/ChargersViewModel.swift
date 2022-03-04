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
     Connection :
     powerKW
     
     ConnectionType :
     title
     
     StatusType :
     isOperational
     isUserSelectable
    */
    
    func filterCharger(with filters: ChargerFilter) {
        _ = $chargePoints
            .map { charger in
                charger.filter({ filters.powerKW == 0 || $0.connections?.first?.powerKW ?? 0.0 < filters.powerKW })
            }
            .sink(receiveValue: { charger in
                self.filteredChargePoints = charger
            })
    }
}

struct ChargerFilter {
    var powerKW: Double = 0.0
}

