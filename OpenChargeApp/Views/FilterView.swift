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
                
            Picker("", selection: $filters.usageType) {
                Text("All").tag(ChargerUsage.all)
                Text("Pay at location").tag(ChargerUsage.isPayAtLocation)
                Text("Membership required").tag(ChargerUsage.isMembershipRequired)
                Text("Access key required").tag(ChargerUsage.isAccessKeyRequired)
            }
            .onChange(of: filters.usageType, perform: { _ in
                chargersViewModel.filterCharger(with: filters)
            })
            .pickerStyle(.segmented)
                                
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
            
            Toggle("Show only operationnal", isOn: $filters.showIsOperational)
                .onReceive(filters.$showIsOperational, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
        }
        .padding()
    }
}

