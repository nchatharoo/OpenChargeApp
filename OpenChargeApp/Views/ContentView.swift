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
    
    @State private var charger: Charger?
    
    @State private var isSheetPresented = false
    
    @State private var isMapTapped = true
    @State private var isListTapped = false
    
    @State private var isChargerTapped = false
    @State private var isFilterTapped = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isMapTapped {
                ScrollViewReader { scrollView in
                        Map(coordinateRegion: $locationViewModel.region,
                            showsUserLocation: true,
                            userTrackingMode: $userTrackingMode,
                            annotationItems: chargersViewModel.chargePoints,
                            annotationContent: { charger in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (charger.addressInfo?.latitude)!, longitude: (charger.addressInfo?.longitude)!)) {
                                ChargerAnnotationView(levelID: charger.connections?.first?.levelID ?? 0)
                                    .onTapGesture(perform: {
                                        self.charger = charger
                                        withAnimation {
                                            isSheetPresented = true
                                            isChargerTapped = true
                                        }
                                    })
                            }
                        })
                }
                .opacity(isMapTapped ? 1 : 0)
                
            } else {
                List {
                    if chargersViewModel.chargePoints.isEmpty {
                        Button {
                            chargersViewModel.loadChargePoints(with: locationViewModel.region.center)
                        } label: {
                            Text("Tap here to retrieve charger points")
                        }
                    }
                    ForEach(chargersViewModel.chargePoints) { charger in
                        HStack(alignment: .center) {
                            VStack(alignment: .center) {
                                ChargerAnnotationView(levelID: charger.connections?.first?.levelID ?? 0)
                                Text("\(charger.connections?.first?.levelID ?? 0)")
                                    .font(.callout)
                            }

                            VStack(alignment: .leading) {
                                Text("\(charger.addressInfo?.title ?? "")")
                                    .fontWeight(.semibold)
                                Text("\(charger.addressInfo?.distance ?? 0.0, specifier: "%.2f") km")
                                    .font(.callout)
                            }
                            Spacer()
                            Image("Caret")
                        }
                        .onTapGesture {
                            self.charger = charger
                            withAnimation {
                                isSheetPresented = true
                                isChargerTapped = true
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(GroupedListStyle())
                .opacity(isListTapped ? 1 : 0)
            }
            
            VStack {
                if chargersViewModel.isProcessing { ProcessingView() }
                
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 90)
                        .cornerRadius(35)
                    
                    HStack(spacing: 60) {
                        Button {
                            isMapTapped = true
                            isListTapped = false
                        } label: {
                            Image("Map")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Button {
                            isMapTapped = false
                            isListTapped = true
                        } label: {
                            Image("List")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Button {
                            chargersViewModel.loadChargePoints(with: locationViewModel.region.center)
                        } label: {
                            Image("Search")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .disabled(chargersViewModel.isProcessing)
                        
                        Button {
                            withAnimation {
                                isSheetPresented = true
                                isFilterTapped = true
                            }
                        } label: {
                            Image("Filters")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                .shadow(color: Color.primary.opacity(0.1), radius: 5)
                .padding()
                .offset(y: isSheetPresented ? 200 : 0)
            }
            
            if isSheetPresented {
                GeometryReader { geometry in
                    BottomSheetView(isOpen: $isSheetPresented, maxHeight: geometry.size.height - 20) {

                        if isChargerTapped {
                            ChargerScrollView(chargers:chargersViewModel.chargePoints, charger: charger!)
                        }
                        
                        if isFilterTapped {
                            Text("Filter View")
                        }
                    }
                }
                .transition(.moveAndFade)
                .onDisappear {
                    isSheetPresented = false
                    isChargerTapped = false
                    isFilterTapped = false
                }
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
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel()
    static var openchargeViewModel = ChargersViewModel(client: URLSessionHTTPClient())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, chargersViewModel: openchargeViewModel)
    }
}
