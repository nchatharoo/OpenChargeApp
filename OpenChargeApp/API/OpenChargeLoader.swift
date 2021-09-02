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
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(completion: @escaping (Error) -> Void = { _ in }) {
        client.get(from: URL(string: "\(baseAPIURL)")!) { error in
            completion(.connectivity)
        }
    }
}
