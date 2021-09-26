//
//  OpenChargeLoader.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation
import MapKit

class OpenChargeViewModel: ObservableObject {
    let openchargeloader: OpenChargeLoader
    var item = Item()
    
    init(openchargeloader: OpenChargeLoader) {
        self.openchargeloader = openchargeloader
    }
    
    func loadItem(with coordinate: CLLocationCoordinate2D, completion: @escaping (OpenChargeLoader.Result) -> Void) {
        self.openchargeloader.load(with: coordinate) { result in
            switch result {
            case let .success(items):
                self.item = items
                print(items)
            case let .failure(error):
                print(error)
            }
            completion(result)
        }
    }
}

public class OpenChargeLoader {
    private let baseAPIURL = "https://api.openchargemap.io/v3/poi/"

    let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success(Item)
        case failure(Error)
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func load(with coordinate: CLLocationCoordinate2D, completion: @escaping (Result) -> Void) {
        let url = URL(string: "\(baseAPIURL)")!
        
        client.get(from: url, with: coordinate) { [weak self] result in
            
            guard self != nil else { return }

            switch result {
            case let .success(data, _):

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

                do {
                    let items = try jsonDecoder.decode(Item.self, from: data)
                    completion(.success(items))
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
