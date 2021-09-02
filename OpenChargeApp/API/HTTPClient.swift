//
//  HTTPClient.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL)
}
