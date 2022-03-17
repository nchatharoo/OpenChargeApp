//
//  FilterView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 07/03/2022.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var chargersViewModel: ChargersViewModel
    @EnvironmentObject var filters: ChargerFiltersViewModel

    var body: some View {
        VStack {
            Text("Select the desired power: \(filters.powerKW, specifier: "%.1f")")
            HStack {
                Image(systemName: "bolt.circle.fill")
                    .font(.title)
                
                Slider(value: $filters.powerKW, in: 0...650) {
                    Text("Power")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("650")
                }
                .accentColor(Color.green)
                .onReceive(filters.$powerKW, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
                
                Image(systemName: "bolt.circle.fill")
                    .font(.largeTitle)
            }
            Text("\(chargersViewModel.filteredChargePoints.count)")
                        
            Toggle("Pay at location", isOn: $filters.isPayAtLocation)
                .onReceive(filters.$isPayAtLocation, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
            
            Toggle("Membership required", isOn: $filters.isMembershipRequired)
                .onReceive(filters.$isMembershipRequired, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
            
            Toggle("Access key required", isOn: $filters.isAccessKeyRequired)
                .onReceive(filters.$isAccessKeyRequired, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
            
            Toggle("Show only operationnal", isOn: $filters.showIsOperational)
                .onReceive(filters.$showIsOperational, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
                                
            List {
                ForEach(Array(filters.connectionType.enumerated()), id: \.1) { (index, type) in
                    Button {
                        filters.connectionIndex = index
                    } label: {
                        Text(type)
                    }
                }
            }
            .onChange(of: filters.connectionIndex, perform: { _ in
                chargersViewModel.filterCharger(with: filters)
            })
        }
        .padding()
    }
}

