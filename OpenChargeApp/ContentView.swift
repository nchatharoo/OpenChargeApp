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
    @StateObject var openchargeViewModel: OpenChargeViewModel
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                Map(coordinateRegion: $locationViewModel.coordinateRegion, showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: openchargeViewModel.item,
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
                .ignoresSafeArea()
                .overlay(
                    VStack {
                        SearchBarView()
                        Spacer()
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 40) {
                                ForEach(openchargeViewModel.item, id: \.self.id) { charger in
                                    VStack {
                                        Text(charger.addressInfo?.title ?? "Title")
                                        Text(charger.addressInfo?.addressLine1 ?? "addressLine1")
                                        Text(charger.addressInfo?.contactTelephone1 ?? "contactTelephone1")
                                        Text(charger.addressInfo?.accessComments ?? "accessComments")
                                    }
                                    .background(Color.red)
                                    .cornerRadius(20)
                                }
                            }
                            .padding()
                            .background(Color.blue)
                            .frame(height: 100)
                        }
                    }
                )
            }
        }
        .onAppear {
            openchargeViewModel.loadItem(with: locationViewModel.coordinateRegion.center) { _ in }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel(locationManager: LocationManager())
    static var openchargeViewModel = OpenChargeViewModel(client: URLSessionHTTPClient())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
    }
}
