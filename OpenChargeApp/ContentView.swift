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
    @State private var displayRipple = false
    @State private var dismissRipple = false
    
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
                            Circle()
                                .strokeBorder(lineWidth: displayRipple ? 1 : 5)
                                .foregroundColor(.green)
                                .frame(width: 40.0, height: 40.0)
                                .scaleEffect(displayRipple ? 1 : 0)
                                .opacity(displayRipple ? 0 : 1)
                                .animation(Animation.easeInOut(duration: 1).delay(0.2).repeatForever(autoreverses: false))
                            
                            Image(systemName: "bolt.circle.fill")
                                .frame(width: 40.0, height: 40.0)
                                .foregroundColor(.green)
                        }
                        .onAppear() {
                            self.displayRipple.toggle()
                        }
                    }
                    .onTapGesture(perform: {
                        proxy.scrollTo(place.id)
                    })
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
    
    func scrollTo(_ place: ChargePoint) {
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel(locationManager: LocationManager())
    static var openchargeViewModel = OpenChargeViewModel(openchargeloader: OpenChargeLoader(client: URLSessionHTTPClient()))
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
    }
}
