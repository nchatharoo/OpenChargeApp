//
//  ContentView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//
import MapKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var chargersViewModel: ChargersViewModel
    @EnvironmentObject var filters: ChargerFiltersViewModel

    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @State private var charger: Charger?
    
    @State private var isSheetPresented = false
    
    @State private var isMapTapped = true
    @State private var isListTapped = false
    
    @State private var isChargerTapped = false
    @State private var isFilterTapped = false
    
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isMapTapped {
                ScrollViewReader { scrollView in
                    Map(coordinateRegion: $locationViewModel.region,
                        showsUserLocation: true,
                        userTrackingMode: $userTrackingMode,
                        annotationItems: chargersViewModel.filteredChargePoints,
                        annotationContent: { charger in
                        MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: (charger.addressInfo?.latitude)!, longitude: (charger.addressInfo?.longitude)!)) {
                            ChargerAnnotationView(levelID: charger.connections?.first?.levelID ?? 0)
                                .onTapGesture(perform: {
                                    self.charger = charger
                                    withAnimation {
                                        isSheetPresented.toggle()
                                        isChargerTapped.toggle()
                                    }
                                })
                        }
                    })
                }
                .opacity(isMapTapped ? 1 : 0)
                
            } else {
                NavigationView {
                    ChargersList {
                        if chargersViewModel.filteredChargePoints.isEmpty {
                            EmptyRowButton
                        }
                        ForEach(chargersViewModel.filteredChargePoints) { charger in
                            Button {
                                self.charger = charger
                                withAnimation {
                                    isSheetPresented.toggle()
                                    isChargerTapped.toggle()
                                }
                            } label: {
                                ChargerRow(charger: charger)
                            }
                        }
                    } onOffsetChange: {
                        scrollOffset = $0
                    }
                    .padding(.horizontal)
                    .navigationTitle("Charging stations")
                }
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
                            chargersViewModel.loadChargers(with: locationViewModel.region.center)
                        } label: {
                            Image("Search")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .disabled(chargersViewModel.isProcessing)
                        
                        Button {
                            withAnimation {
                                isSheetPresented.toggle()
                                isFilterTapped.toggle()
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
                .offset(y: isListTapped ? -scrollOffset : 0)
                .transition(.moveAndFade)
                .animation(.default, value: isSheetPresented)
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
                chargersViewModel.loadChargers(with: locationViewModel.region.center)
            }), secondaryButton: .default(Text("Cancel")))
        }
        .sheet(isPresented: $isChargerTapped, onDismiss: {
            isSheetPresented.toggle()
        }, content: {
            ChargerScrollView(chargers:chargersViewModel.filteredChargePoints, charger: charger!)
                .environmentObject(locationViewModel)
        })
        .sheet(isPresented: $isFilterTapped, onDismiss: {
            isSheetPresented.toggle()
        }, content: {
            FilterView()
                .environmentObject(chargersViewModel)
                .environmentObject(filters)
        })
        .ignoresSafeArea()
    }
    
    var EmptyRowButton: some View {
        Button {
            chargersViewModel.loadChargers(with: locationViewModel.region.center)
        } label: {
            HStack(alignment: .center) {
                Text("Tap here to retrieve charger points")
                Spacer()
                Image("Caret")
            }
        }
        .padding(.horizontal)
        .foregroundColor(Color.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
