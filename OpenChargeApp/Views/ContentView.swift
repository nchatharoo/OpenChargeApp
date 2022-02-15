//
//  ContentView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var locationViewModel: LocationViewModel
    @StateObject var openchargeViewModel: ChargePointViewModel
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                Map(coordinateRegion: $locationViewModel.coordinateRegion, showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: openchargeViewModel.items,
                annotationContent: { place in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (place.addressInfo?.latitude)!, longitude: (place.addressInfo?.longitude)!)) {
                    VStack {
                        ZStack {
                            Image(systemName: "bolt.circle.fill")
                                .frame(width: 40.0, height: 40.0)
                                .foregroundColor(.green)
                        }
                    }
                    .onTapGesture(perform: {
                        proxy.scrollTo(place.id)
                    })
                }
                })
            }
            VStack {
                SearchBarView()
                    .padding(.top)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 40) {
                        ForEach(openchargeViewModel.items, id: \.self.id) { charger in
                            VStack {
                                Text(charger.addressInfo?.title ?? "")
                                Text(charger.addressInfo?.addressLine1 ?? "")
                                Text(charger.addressInfo?.contactTelephone1 ?? "")
                                Text(charger.addressInfo?.accessComments ?? "")
                            }
                            .background(Color.red)
                            .cornerRadius(20)
                        }
                    }
                    .background(Color.blue)
                    .frame(height: 100)
                }
            }
            if openchargeViewModel.isProcessing { ProcessingView() }
        }
        .alert(isPresented: $locationViewModel.isDeniedOrRestricted, content: {
            Alert(title: Text(locationViewModel.permission.title),
                  message: Text(locationViewModel.permission.message),
                  dismissButton: .default(Text(locationViewModel.permission.dismissButtonTitle), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: locationViewModel.coordinateRegion.center, perform: { newCoordinate in
            openchargeViewModel.loadChargePoints(with: newCoordinate)
        })
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel()
    static var openchargeViewModel = ChargePointViewModel(client: URLSessionHTTPClient())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
    }
}
