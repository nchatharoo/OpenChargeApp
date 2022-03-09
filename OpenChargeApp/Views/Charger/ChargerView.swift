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
        VStack {
            VStack {
                HStack {
                    AsyncImage(url: URL(string: chargerViewModel.itemThumbnailURL())) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 50, height: 50)
                        
                    } placeholder: {
                        Image(systemName: "bolt.car")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    
                    Text(chargerViewModel.operatorInfoTitle())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                HStack {
                    mailButton
                    phoneButton
                    websiteButton
                }
            }
            
            VStack {
                Text(chargerViewModel.addressTitle())
                    .fontWeight(.bold)
                Text((chargerViewModel.addressLine()) + " " + (chargerViewModel.addressTown()))
                    .fontWeight(.thin)
                Text(chargerViewModel.postcode())
                    .fontWeight(.thin)

                HStack {
                    Image(systemName: "mappin")
                    Text("\(chargerViewModel.distance(), specifier: "%.2f") km")
                }
                .foregroundColor(.green)
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
                Text("Cost: \(chargerViewModel.usageCost())")
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
                .foregroundColor(chargerViewModel.operatorInfoPrimaryPhone() == nil ? .secondary : .primary)
        }.disabled(chargerViewModel.operatorInfoPrimaryPhone() == nil)
    }
    
    var websiteButton: some View {
        Button {
            UIApplication.shared.open( chargerViewModel.operatorInfoBookingURL()!)
        } label: {
            Image("Web")
                .renderingMode(.template)
                .foregroundColor(chargerViewModel.operatorInfoBookingURL() == nil ? .secondary : .primary)
        }.disabled(chargerViewModel.operatorInfoBookingURL() == nil)
    }
}
