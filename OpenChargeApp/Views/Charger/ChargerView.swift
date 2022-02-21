//
//  ChargerView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 21/02/2022.
//

import SwiftUI

struct ChargerView: View {
    let charger: Charger
    
    var body: some View {
        VStack {
            VStack {
                Text(charger.addressInfo?.title ?? "")
                    .fontWeight(.bold)
                Text((charger.addressInfo?.addressLine1 ?? "") + " " + (charger.addressInfo?.town ?? ""))
                    .fontWeight(.thin)
                Text(charger.addressInfo?.stateOrProvince ?? "")
                Text(charger.addressInfo?.postcode ?? "")
                Text("\(charger.addressInfo?.distance ?? 0.0, specifier: "%.2f") km")
            }
            VStack {
                Text("Type of connection: \(charger.connections?.first?.connectionType?.title ?? "")")
                Text("Status: \(charger.connections?.first?.statusType?.title ?? "Unkown")")
            }
            VStack {
                Text("Level: \(charger.connections?.first?.level?.title ?? "")")
                Text(charger.connections?.first?.level?.comments ?? "")
            }
            VStack {
                Text("Type: \(charger.connections?.first?.currentType?.title ?? "")")
            }
            VStack {
                Text("Quantity: \(charger.connections?.first?.quantity ?? 0)")
            }
            VStack {
                Text("Number of bays: \(charger.numberOfPoints ?? 0)")
            }
            VStack {
                Text("Usage type: \(charger.usageType?.title ?? "")")
            }
        }
        .background(Color.white)
    }
}
