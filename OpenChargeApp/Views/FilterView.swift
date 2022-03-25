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
//            Text("\(chargersViewModel.filteredChargePoints.count)")

            Text("Select the desired power: \(filters.powerKW, specifier: "%.1f")")
            HStack {
                Image("Status")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.green)

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
                
                Image("Status")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
            }
                        
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

struct FilterView_Previews: PreviewProvider {
    static let charger = Charger(dataProvider: nil,
                                 operatorInfo: OperatorInfo(websiteURL: "http://a-url.com", comments: "any comment", phonePrimaryContact: "0123456789", phoneSecondaryContact: "0123456789", isPrivateIndividual: nil, addressInfo: nil, bookingURL: nil, contactEmail: nil, faultReportEmail: nil, isRestrictedEdit: nil, id: nil, title: "any title"),
                                 usageType: UsageType(isPayAtLocation: true,
                                                      isMembershipRequired: false,
                                                      isAccessKeyRequired: true,
                                                      id: nil,
                                                      title: "Public - Membership Required"),
                                 statusType: nil,
                                 submissionStatus: nil,
                                 userComments: nil,
                                 percentageSimilarity: nil,
                                 mediaItems: nil,
                                 isRecentlyVerified: nil,
                                 dateLastVerified: nil,
                                 id: nil,
                                 uuid: UUID().uuidString,
                                 parentChargePointID: nil,
                                 dataProviderID: nil,
                                 dataProvidersReference: nil,
                                 operatorID: nil,
                                 operatorsReference: nil,
                                 usageTypeID: nil,
                                 usageCost: "£0.073/minute; min £1.38; other tariffs available",
                                 addressInfo: AddressInfo(id: nil, title: "any address title", addressLine1: "any address line", addressLine2: nil, town: "any town", stateOrProvince: "any state", postcode: "any postcode", countryID: nil, country: nil, latitude: 0.0, longitude: 0.0, contactTelephone1: "0123456789", contactTelephone2: nil, contactEmail: nil, accessComments: nil, relatedURL: nil, distance: 0.1, distanceUnit: nil),
                                 connections: [Connection(id: nil, connectionTypeID: 2, connectionType: ConnectionType(formalName: "a formalName", isDiscontinued: nil, isObsolete: nil, id: nil, title: "GB-T AC - GB/T 20234.2 (Tethered Cable)"), reference: nil, statusTypeID: nil, statusType: StatusType(isOperational: true, isUserSelectable: true, id: nil, title: "Operational"), levelID: nil, level: Level(comments: "Over 2 kW, usually non-domestic socket types", isFastChargeCapable: true, id: nil, title: "Level 2 : Medium (Over 2kW)"), amps: 10, voltage: 10, powerKW: 10.0, currentTypeID: nil, currentType: CurrentType(currentTypeDescription: "a current type description", id: nil, title: "AC (Single-Phase)"), quantity: 2, comments: "a current type comment")],
                                 numberOfPoints: 4,
                                 generalComments: nil,
                                 datePlanned: nil,
                                 dateLastConfirmed: nil,
                                 statusTypeID: nil,
                                 dateLastStatusUpdate: Date(),
                                 dataQualityLevel: nil,
                                 dateCreated: Date(),
                                 submissionStatusTypeID: nil)
    

    static var chargersViewModel = ChargersViewModel(client: URLSessionHTTPClient())
    static var filters = ChargerFiltersViewModel()
    
    static var previews: some View {
        FilterView()
            .environmentObject(chargersViewModel)
            .environmentObject(filters)
    }
}
