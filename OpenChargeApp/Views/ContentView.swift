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
    @StateObject var chargePointViewModel: ChargePointViewModel
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ZStack(alignment: .bottom) {
                    Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true,
                        userTrackingMode: $userTrackingMode,
                        annotationItems: chargePointViewModel.chargePoints,
                        annotationContent: { place in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (place.addressInfo?.latitude)!, longitude: (place.addressInfo?.longitude)!)) {
                            PlaceAnnotationView()
                                .onTapGesture(perform: {
                                    withAnimation {
                                        proxy.scrollTo(place.id)
                                    }
                                })
                        }
                    })
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 40) {
                            ForEach(chargePointViewModel.chargePoints, id: \.id) { charger in
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
            }
            if chargePointViewModel.isProcessing { ProcessingView() }
        }
        .onReceive(locationViewModel.getLastCoordinate()) { coordinate in
            chargePointViewModel.loadChargePoints(with: coordinate)
        }
        .alert(isPresented: $locationViewModel.isDeniedOrRestricted, content: {
            Alert(title: Text(locationViewModel.permission.title),
                  message: Text(locationViewModel.permission.message),
                  dismissButton: .default(Text(locationViewModel.permission.dismissButtonTitle), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .alert(item: $chargePointViewModel.networkError) { networkError in
            Alert(title: Text(networkError.title), message: Text(networkError.message),
                  primaryButton: .default(Text("Retry"), action: {
                chargePointViewModel.loadChargePoints(with: locationViewModel.region.center)
            }), secondaryButton: .default(Text("Cancel")))
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel()
    static var openchargeViewModel = ChargePointViewModel(client: URLSessionHTTPClient())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, chargePointViewModel: openchargeViewModel)
    }
}
