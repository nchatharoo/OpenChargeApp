//
//  OpenChargeViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/01/2022.
//

import Foundation
import MapKit
import Combine

final public class OpenChargeViewModel: ObservableObject {
    let openchargeloader: OpenChargeLoader
    @Published public var item = Charge()
    
    public init(openchargeloader: OpenChargeLoader) {
        self.openchargeloader = openchargeloader
    }

    public func loadItem(with coordinate: CLLocationCoordinate2D, completion: @escaping (OpenChargeLoader.Result) -> Void) {
        self.openchargeloader.load(with: coordinate) { result in
            switch result {
            case let .success(items):
                DispatchQueue.main.async {
                    self.item = items
                }
                print(items)
            case let .failure(error):
                print(error)
            }
            completion(result)
        }
    }
}
