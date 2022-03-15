//
//  ChargerFilter.swift
//  OpenChargeApp
//
//  Created by Nadheer on 09/03/2022.
//

import Foundation

class ChargerFiltersViewModel: ObservableObject {
    
    @Published var usageType: ChargerUsage = .all
    @Published var powerKW: Double = 0.0
    @Published var showIsOperational: Bool = false
    @Published var connectionIndex: Int = 0
    @Published var connectionType = [
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
