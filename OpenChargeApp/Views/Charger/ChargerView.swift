//
//  ChargerView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 21/02/2022.
//

import SwiftUI

struct ChargerView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    let chargerViewModel: ChargerViewModel
    
    @State private var directions: [String] = []
    
    init(chargerViewModel: ChargerViewModel) {
        self.chargerViewModel = chargerViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                Text(chargerViewModel.operatorInfoTitle())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding([.top, .horizontal])
            
                MapView(directions: $directions)
                    .cornerRadius(20)
                    .shadow(color: .primary.opacity(0.3), radius: 3)
                    .disabled(true)
                    .environmentObject(locationViewModel)
                    .environmentObject(chargerViewModel)
            
            VStack(alignment: .leading) {
                
                HStack(alignment: .center) {
                    Image("Location")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                    Text(chargerViewModel.addressTitle())
                    
                    Text("\(chargerViewModel.distance(), specifier: "%.2f") km")
                        .font(.system(.footnote))
                        .fontWeight(.light)
                }
                
                HStack(alignment: .center) {
                    Image("Wallet")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                    Text("\(chargerViewModel.usageCost())")
                }
                
                Text(chargerViewModel.usageTypeTitle())

                HStack(alignment: .center) {
                    Image("Status")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                    Text("\(chargerViewModel.statusTitle().uppercased())")
                }
                .foregroundColor(chargerViewModel.statusIsOperational() ? .green : .red)
            }
            .font(.system(.subheadline))
            .padding([.top, .horizontal])

            GeometryReader { geometry in

            ScrollView(.vertical, showsIndicators: false) {
                ForEach(chargerViewModel.connections(), id: \.id) { connection in
                        HStack(alignment: .center) {
                            chargerViewModel.connectionTypeImage(connection)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 70, height: 70)
                                                        
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("\(chargerViewModel.connectionType(connection))")
                                    .fontWeight(.bold)
                                
                                Text("\(chargerViewModel.currentTypeTitle(connection)) x \(Text(chargerViewModel.quantity(connection)))")
                                    .font(.system(.footnote))
                                
                                HStack(alignment: .center) {
                                    Text(chargerViewModel.amps(connection))
                                    Text(chargerViewModel.voltage(connection))
                                    Text(chargerViewModel.powerKW(connection))
                                }
                                .foregroundColor(.gray).opacity(0.8)
                                .font(.system(.footnote))
                            }
                        }
                        .padding([.top, .horizontal])
                    }
                .frame(width: geometry.size.width)
                }
            }
            .padding(.bottom)
            
            directionsButton
                .padding(.bottom)
        }
        .padding(.horizontal)
    }
    
    var directionsButton: some View {
        Button {
            let latitude = chargerViewModel.coordinate().latitude
            let longitude = chargerViewModel.coordinate().longitude
            let url = URL(string: "http://maps.apple.com/?ll=\(latitude.description),\(longitude.description)")
            UIApplication.shared.open(url!)
        } label: {
            Text("Directions")
                .frame(maxWidth: 300)
                .padding()
                .background(.green)
                .clipShape(Capsule())
                .foregroundColor(Color.white)
        }
    }
}

struct ChargerView_Previews: PreviewProvider {
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
    
    static var chargerViewModel = ChargerViewModel(charger: charger)
    static var locationViewModel = LocationViewModel()
    static var previews: some View {
        ChargerView(chargerViewModel: chargerViewModel)
            .environmentObject(locationViewModel)
            .environmentObject(chargerViewModel)

    }
}
