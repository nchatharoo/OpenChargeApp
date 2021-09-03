//
//  OpenChargeLoader.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation

public class OpenChargeLoader {
    private let baseAPIURL = "https://api.openchargemap.io/v3/poi/"
    private let apiKey = "6bdc7787-1e5b-4567-920a-9a77632ccb96"

    let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success(Item)
        case failure(Error)
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (Result) -> Void) {
        let url = URL(string: "\(baseAPIURL)")!
        
        client.get(from: url) { result in
            switch result {
            case let .success(data, _):
                if let items = try? JSONDecoder().decode(Item.self, from: data) {
                    completion(.success(items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
