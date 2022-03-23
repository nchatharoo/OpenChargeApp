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
    @State private var showDirections = false
    
    init(chargerViewModel: ChargerViewModel) {
        self.chargerViewModel = chargerViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text(chargerViewModel.operatorInfoTitle())
                    .font(.largeTitle)
                    .fontWeight(.bold)

//                HStack {
//                    mailButton
//                    phoneButton
//                    websiteButton
//                }
            }
            
            VStack(alignment: .leading) {
//                Text((chargerViewModel.addressLine()) + " " + (chargerViewModel.addressTown()))
//                    .fontWeight(.thin)
//                Text(chargerViewModel.postcode())
//                    .fontWeight(.thin)
                HStack {
                    Image("Location")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)

                    Text(chargerViewModel.addressLine())

                    Text("\(chargerViewModel.distance(), specifier: "%.2f") km")
                        .font(.system(size: 14, weight: .light))
                }
                
                HStack {
                    Image("Status")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)

                    Text("\(chargerViewModel.statusTitle().uppercased())")
                }
                .foregroundColor(chargerViewModel.statusIsOperational() ? .green : .red)
            }
            VStack {
                VStack {
                    Text("Type: \(chargerViewModel.currentTypeTitle())")
                        .fontWeight(.bold)
                    Text("Connector: ")
                    Text("\(chargerViewModel.connectionType())")
                }
                .padding()
                .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.green, lineWidth: 1)
                    )
            }
            VStack {
                Text("Level: \(chargerViewModel.levelTitle())")
                Text(chargerViewModel.levelComments())
                Text(chargerViewModel.amps())
                Text(chargerViewModel.voltage())
                Text(chargerViewModel.powerKW())
            }
            VStack {
                Text("Type: \(chargerViewModel.currentTypeTitle()) x \(Text(chargerViewModel.quantity()))")
            }
            VStack {
                Text("Number of bays: \(chargerViewModel.numberOfPoints())")
            }
            VStack {
                Text("Cost: \(chargerViewModel.usageCost())")
            }
            VStack {
                Text(chargerViewModel.usageTypeTitle())
                
                HStack {
                    VStack {
                        Image("Pay")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(chargerViewModel.isPayAtLocation() ? .secondary : .primary)
                        Text("Payment")
                            .fontWeight(.thin)
                            .font(.footnote)
                    }
                    
                    VStack {
                        Image("Member")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(chargerViewModel.isMembershipRequired() ? .secondary : .primary)
                        Text("Membership")
                            .fontWeight(.thin)
                            .font(.footnote)
                    }
                    
                    VStack {
                        Image("Key")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(chargerViewModel.isAccessKeyRequired() ? .secondary : .primary)
                        Text("Access key")         .fontWeight(.thin)
                            .font(.footnote)
                    }
                }

            }
            VStack {
                directionsButton
            }
        }
        .background(Color.white)
        .sheet(isPresented: $showDirections, content: {
            VStack {
                MapView(directions: $directions)
                    .environmentObject(locationViewModel)
                    .environmentObject(chargerViewModel)
                
                Button {
                    self.showDirections.toggle()
                } label: {
                    Text("Dismiss")
                }
            }
        })
    }
    
    var directionsButton: some View {
        Button {
            self.showDirections.toggle()
        } label: {
            Text("Directions")
                .padding()
                .background(.green)
                .clipShape(Capsule())
                .foregroundColor(Color.white)
        }
    }
    
    var mailButton: some View {
        Button {
            UIApplication.shared.open(chargerViewModel.operatorInfoEmail()!)
        } label: {
            Image("Mail")
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(chargerViewModel.operatorInfoEmail() == nil ? .secondary : .primary)
        }
        .disabled(chargerViewModel.operatorInfoEmail() == nil)
    }
    
    var phoneButton: some View {
        Button {
            UIApplication.shared.open(chargerViewModel.operatorInfoPrimaryPhone()!)
        } label: {
            Image("Phone")
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(chargerViewModel.operatorInfoPrimaryPhone() == nil ? .secondary : .primary)
        }.disabled(chargerViewModel.operatorInfoPrimaryPhone() == nil)
    }
    
    var websiteButton: some View {
        Button {
            UIApplication.shared.open( chargerViewModel.operatorInfoBookingURL()!)
        } label: {
            Image("Web")
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(chargerViewModel.operatorInfoBookingURL() == nil ? .secondary : .primary)
        }.disabled(chargerViewModel.operatorInfoBookingURL() == nil)
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
                       usageCost: "a usage cost",
                       addressInfo: AddressInfo(id: nil, title: "any address title", addressLine1: "any address line", addressLine2: nil, town: "any town", stateOrProvince: "any state", postcode: "any postcode", countryID: nil, country: nil, latitude: 0.0, longitude: 0.0, contactTelephone1: "0123456789", contactTelephone2: nil, contactEmail: nil, accessComments: nil, relatedURL: nil, distance: 0.1, distanceUnit: nil),
                       connections: [Connection(id: nil, connectionTypeID: nil, connectionType: ConnectionType(formalName: "a formalName", isDiscontinued: nil, isObsolete: nil, id: nil, title: "GB-T AC - GB/T 20234.2 (Tethered Cable)"), reference: nil, statusTypeID: nil, statusType: StatusType(isOperational: true, isUserSelectable: true, id: nil, title: "Operational"), levelID: nil, level: Level(comments: "Over 2 kW, usually non-domestic socket types", isFastChargeCapable: true, id: nil, title: "Level 2 : Medium (Over 2kW)"), amps: 10, voltage: 10, powerKW: 10.0, currentTypeID: nil, currentType: CurrentType(currentTypeDescription: "a current type description", id: nil, title: "AC (Single-Phase)"), quantity: 2, comments: "a current type comment")],
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
    static var previews: some View {
        ChargerView(chargerViewModel: chargerViewModel)
    }
}
