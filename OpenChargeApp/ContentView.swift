//
//  ContentView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    @ObservedObject var openchargeViewModel: OpenChargeViewModel
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var value = 1.0
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationViewModel.coordinateRegion, showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: openchargeViewModel.item,
                annotationContent: { place in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (place.addressInfo?.latitude)!, longitude: (place.addressInfo?.longitude)!)) {
                    VStack {
                        Image(systemName: "bolt.circle.fill")
                        
                            .frame(width: 20.0, height: 20.0)
                            .foregroundColor(.yellow)
                            .opacity(value)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true))
                            .onAppear { self.value = 0.2 }
                    }
                }
            })
                .overlay(
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 40) {
                            ForEach(openchargeViewModel.item, id: \.self.id) { charger in
                                VStack {
                                    Text(charger.addressInfo?.title ?? "")
                                    Text(charger.addressInfo?.addressLine1 ?? "")
                                    Text(charger.addressInfo?.contactTelephone1 ?? "")
                                }
                                .frame(width: 300)
                                .background(Color.red)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .frame(height: 100)
                        .cornerRadius(20)
                    }.tabViewStyle(PageTabViewStyle())
                    
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        openchargeViewModel.loadItem(with: locationViewModel.coordinateRegion.center) { _ in }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel(locationManager: LocationManager())
    static var openchargeViewModel = OpenChargeViewModel(openchargeloader: OpenChargeLoader(client: URLSessionHTTPClient()))
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
    }
}
