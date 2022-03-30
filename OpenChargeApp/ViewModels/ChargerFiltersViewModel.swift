//
//  ChargerFilter.swift
//  OpenChargeApp
//
//  Created by Nadheer on 09/03/2022.
//

import Foundation
import SwiftUI

class ChargerFiltersViewModel: ObservableObject {
    
    @Published var powerKW: Double = 0.0
    @Published var showIsOperational: Bool = false
    @Published var isPayAtLocation: Bool = false
    @Published var isMembershipRequired: Bool = false
    @Published var isAccessKeyRequired: Bool = false
}
