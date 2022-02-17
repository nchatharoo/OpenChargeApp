//
//  ContentView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//
import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject var locationViewModel: LocationViewModel
    @StateObject var chargePointViewModel: ChargePointViewModel
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isSheetActive = false
    
    var body: some View {
        ZStack {
            ScrollViewReader { scrollView in
                ZStack(alignment: .bottom) {
                    Map(coordinateRegion: $locationViewModel.region,
                        showsUserLocation: true,
                        userTrackingMode: $userTrackingMode,
                        annotationItems: chargePointViewModel.chargePoints,
                        annotationContent: { place in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (place.addressInfo?.latitude)!, longitude: (place.addressInfo?.longitude)!)) {
                            PlaceAnnotationView()
                                .onTapGesture(perform: {
                                    withAnimation {
                                        scrollView.scrollTo(place.id)
                                        isSheetActive.toggle()
                                    }
                                })
                        }
                    })
                    
                    BottomBarView()
                        .offset(y: isSheetActive ? 200 : 0)
                    
                    if isSheetActive {
                        GeometryReader { geometry in
                            BottomSheetView(isOpen: $isSheetActive, maxHeight: geometry.size.height / 1.4) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 40) {
                                        ForEach(chargePointViewModel.chargePoints, id: \.id) { charger in
                                            VStack {
                                                Text(charger.addressInfo?.title ?? "")
                                                Text(charger.addressInfo?.addressLine1 ?? "")
                                                Text(charger.addressInfo?.contactTelephone1 ?? "")
                                                Text(charger.addressInfo?.accessComments ?? "")
                                            }
                                            .background(Color.white)
                                        }
                                    }
                                }
                            }
                        }
                        .transition(.moveAndFade)
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
                  primaryButton: .default(Text(locationViewModel.permission.dismissButtonTitle), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }), secondaryButton: .default(Text("Cancel")))
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
