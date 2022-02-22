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
    @StateObject var chargersViewModel: ChargersViewModel
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isAnnotationTapped = false
    
    @State private var charger: Charger?
    
    @State private var isMapTapped = true
    @State private var isListTapped = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isMapTapped {
                ScrollViewReader { scrollView in
                        Map(coordinateRegion: $locationViewModel.region,
                            showsUserLocation: true,
                            userTrackingMode: $userTrackingMode,
                            annotationItems: chargersViewModel.chargePoints,
                            annotationContent: { place in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (place.addressInfo?.latitude)!, longitude: (place.addressInfo?.longitude)!)) {
                                ChargerAnnotationView(levelID: place.connections?.first?.levelID ?? 0)
                                    .onTapGesture(perform: {
                                        charger = place
                                        withAnimation {
                                            isAnnotationTapped.toggle()
                                        }
                                    })
                            }
                        })
                }
                .opacity(isMapTapped ? 1 : 0)
                .animation(.linear, value: isMapTapped)
                
            } else {
                Color.red
                    .opacity(isListTapped ? 1 : 0)
                    .animation(.linear, value: isListTapped)
            }
            
            VStack {
                if chargersViewModel.isProcessing { ProcessingView() }
                
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 90)
                        .cornerRadius(35)
                    
                    HStack(spacing: 60) {
                        Image("Map-location")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                isMapTapped = true
                                isListTapped = false
                            }
                        
                        Image("Search")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                chargersViewModel.loadChargePoints(with: locationViewModel.region.center)
                            }
                        
                        Image("Rows")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                isMapTapped = false
                                isListTapped = true
                            }
                    }
                }
                .shadow(color: Color.primary.opacity(0.1), radius: 5)
                .padding()
                .offset(y: isAnnotationTapped ? 200 : 0)
            }
            
            if isAnnotationTapped {
                GeometryReader { geometry in
                    BottomSheetView(isOpen: $isAnnotationTapped, maxHeight: geometry.size.height) {
                        ChargerScrollView(chargers:chargersViewModel.chargePoints, charger: charger!)
                    }
                }
                .transition(.moveAndFade)
            }
        }
        .alert(isPresented: $locationViewModel.isDeniedOrRestricted, content: {
            Alert(title: Text(locationViewModel.permission.title),
                  message: Text(locationViewModel.permission.message),
                  primaryButton: .default(Text(locationViewModel.permission.dismissButtonTitle), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }), secondaryButton: .default(Text("Cancel")))
        })
        .alert(item: $chargersViewModel.networkError) { networkError in
            Alert(title: Text(networkError.title), message: Text(networkError.message),
                  primaryButton: .default(Text("Retry"), action: {
                chargersViewModel.loadChargePoints(with: locationViewModel.region.center)
            }), secondaryButton: .default(Text("Cancel")))
        }
        .ignoresSafeArea()
    }
    
    func didDismiss() {
            // Handle the dismissing action.
        }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel()
    static var openchargeViewModel = ChargersViewModel(client: URLSessionHTTPClient())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, chargersViewModel: openchargeViewModel)
    }
}
