//
//  ChargerView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 21/02/2022.
//

import SwiftUI

struct ChargerView: View {
    let chargerViewModel: ChargerViewModel
    
    init(chargerViewModel: ChargerViewModel) {
        self.chargerViewModel = chargerViewModel
    }
    
    var body: some View {
        VStack {
            VStack {
                Text(chargerViewModel.operatorInfoTitle())
                    .fontWeight(.bold)
                Text(chargerViewModel.operatorInfoEmail())
                Text(chargerViewModel.operatorInfoPrimaryPhone())
                Text(chargerViewModel.operatorInfoBookingURL())
            }
            VStack {
                Text(chargerViewModel.addressTitle())
                    .fontWeight(.bold)
                Text((chargerViewModel.addressLine()) + " " + (chargerViewModel.addressTown()))
                    .fontWeight(.thin)
                Text(chargerViewModel.stateOrProvince())
                Text(chargerViewModel.postcode())
                Text("\(chargerViewModel.distance(), specifier: "%.2f") km")
            }
            VStack {
                Text("\(chargerViewModel.connectionType())")
                Text("Status: \(chargerViewModel.statusTitle())")
                    .foregroundColor(chargerViewModel.statusIsOperational() ? .green : .red)
            }
            VStack {
                Text("Level: \(chargerViewModel.levelTitle())")
                Text(chargerViewModel.levelComments())
                Text(chargerViewModel.amps())
                Text(chargerViewModel.voltage())
                Text(chargerViewModel.powerKW())
            }
            VStack {
                Text("Type: \(chargerViewModel.currentTypeTitle())")
            }
            VStack {
                Text(chargerViewModel.quantity())
            }
            VStack {
                Text("Number of bays: \(chargerViewModel.numberOfPoints())")
            }
            VStack {
                Text(chargerViewModel.usageTypeTitle())
                HStack {
                    Image("Pay")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(chargerViewModel.isPayAtLocation() ? .yellow : .gray)
                    Image("Member")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(chargerViewModel.isMembershipRequired() ? .yellow : .gray)
                    Image("Key")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(chargerViewModel.isAccessKeyRequired() ? .yellow : .gray)
                }
            }
        }
        .background(Color.white)
    }
}
