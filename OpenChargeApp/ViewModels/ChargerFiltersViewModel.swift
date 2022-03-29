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

    @Published var connectionIndex: Int = 0
    @Published var isSelected = false
    @Published var connectionType = [
        /*"Avcon Connector",
        "BS1363 3 Pin 13 Amp",
        "Blue Commando (2P+E)",
        "CEE 3 Pin",
        "CEE 5 Pin",
        "CEE 7/4 - Schuko - Type F",
        "CEE 7/5",
        "CEE+ 7 Pin",
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
        "Three Phase 5-Pin (AS/NZ 3123)",*/
        "CCS (Type 1)",
        "CCS (Type 2)",
        "Type 1 (J1772)",
        "Type 2 (Socket Only)",
        "Type 2 (Tethered Connector)",
        "CHAdeMO",
        "Other types",
    ]
    
    func connectionTypeImage(_ connectionType: String) -> Image {
        switch connectionType {
        case "Type 1 (J1772)":
            return Image("Type1_J1772")
        case "CHAdeMO":
            return Image("Chademo_type4")
        case "Type 2 (Socket Only)":
            return Image("Type2_socket")
        case "CCS (Type 1)":
            return Image("Type1_CCS")
        case "CCS (Type 2)":
            return Image("Type2_CCS")
        case "Type 2 (Tethered Connector)":
            return Image("Type2_tethered")
        default:
            return Image("Unknown")
        }
    }

}
