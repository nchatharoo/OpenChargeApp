//
//  FilterView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 07/03/2022.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var chargersViewModel: ChargersViewModel
    
    @State private var filters: ChargerFilter = ChargerFilter()
    
    @State private var powerKw: Double = 0
    @State private var selectedUsage: ChargerUsage = .all
    @State private var showIsOperational: Bool = false

    var body: some View {
        VStack {
            Text("Select the desired power: \(powerKw, specifier: "%.1f")")
            HStack {
                Image(systemName: "bolt.circle.fill")
                    .font(.title)
                Slider(value: $powerKw, in: 0...650) {
                    Text("Power")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("650")
                } onEditingChanged: { _ in
                    filters.powerKW = powerKw
                }
                .accentColor(Color.green)
                Image(systemName: "bolt.circle.fill")
                    .font(.largeTitle)
            }
            Text("\(chargersViewModel.filteredChargePoints.count)")
                
            Picker("", selection: $selectedUsage) {
                Text("All").tag(ChargerUsage.all)
                Text("Pay at location").tag(ChargerUsage.isPayAtLocation)
                Text("Membership required").tag(ChargerUsage.isMembershipRequired)
                Text("Access key required").tag(ChargerUsage.isAccessKeyRequired)
            }
            .onChange(of: selectedUsage, perform: { newValue in
                filters.usageType = newValue
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
            
            Toggle("Show only operationnal", isOn: $showIsOperational)
            
        }
        .onChange(of: showIsOperational, perform: { newValue in
            filters.showIsOperational = newValue
        })
        .onChange(of: filters, perform: { newValue in
            chargersViewModel.filterCharger(with: filters)
        })
        .padding()
    }
}

