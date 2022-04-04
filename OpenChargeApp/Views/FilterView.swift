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
        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 0) {
                Text("Chargers available: ")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(chargersViewModel.filteredChargePoints.count)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(chargersViewModel.filteredChargePoints.count == 0 ? .primary : .green)
            }
            
            PowerSlider()
                .environmentObject(filters)
                .onReceive(filters.$powerKW, perform: { _ in
                    chargersViewModel.filterCharger(with: filters)
                })
               
            HStack {
                Image("Wallet")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(6)
                    .background(
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                        }
                    )

                Toggle("Show free charger", isOn: $filters.isPayAtLocation)
                    .onReceive(filters.$isPayAtLocation, perform: { _ in
                        chargersViewModel.filterCharger(with: filters)
                    })
            }
            
            HStack {
                Image("Key")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(6)
                    .background(
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                        }
                    )
                
                Toggle("Show public charger", isOn: $filters.isMembershipRequired)
                    .onReceive(filters.$isMembershipRequired, perform: { _ in
                        chargersViewModel.filterCharger(with: filters)
                    })
            }
            
            HStack {
                Image("Member")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(6)
                    .background(
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                        }
                    )

                Toggle("Show with membership", isOn: $filters.isAccessKeyRequired)
                    .onReceive(filters.$isAccessKeyRequired, perform: { _ in
                        chargersViewModel.filterCharger(with: filters)
                    })
            }
            
//            HStack {
//                Image("Status")
//                    .resizable()
//                    .renderingMode(.template)
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//                    .padding(6)
//                    .background(
//                        ZStack {
//                            Circle()
//                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
//                            Circle()
//                                .foregroundStyle(.ultraThinMaterial)
//                        }
//                    )
//
//                Toggle("Show only operationnal", isOn: $filters.showIsOperational)
//                    .onReceive(filters.$showIsOperational, perform: { _ in
//                        chargersViewModel.filterCharger(with: filters)
//                    })
//            }
        }
        .padding()
    }
}

struct PowerSlider: View {
    @EnvironmentObject var filters: ChargerFiltersViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select the desired power: \(filters.powerKW, specifier: "%.1f") kW")
                .font(.system(.body))
            
            HStack {
                Button (action: {
                    filters.powerKW -= 1
                }, label: {
                    Image("Status")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                })
                    .padding(6)
                    .background(
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                        }
                    )

                Slider(value: $filters.powerKW, in: 0...650) {
                    Text("Power")
                } minimumValueLabel: {
                    Text("0 kW")
                } maximumValueLabel: {
                    Text("650 kW")
                }
                .accentColor(Color.green)
                
                Button (action: {
                    filters.powerKW += 1
                }, label: {
                    ZStack {
                        Image("Status")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    }
                })
                    .padding(6)
                    .background(
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                            Circle()
                                .foregroundStyle(.ultraThinMaterial)
                        }
                    )
            }
        }
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
