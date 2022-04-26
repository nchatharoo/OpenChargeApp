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
                            Button {
                                self.charger = charger
                                isSheetPresented.toggle()
                                isChargerTapped.toggle()
                            } label: {
                                ChargerAnnotationView(levelID: charger.connections?.first?.levelID ?? 0)
                            }
                        }
                    })
                }
                .opacity(isMapTapped ? 1 : 0)
                .animation(.spring(), value: isMapTapped)
                
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
                    .navigationTitle("Around you")
                }
                .opacity(isListTapped ? 1 : 0)
                .animation(.spring(), value: isListTapped)
            }
            
            VStack {
                if chargersViewModel.isProcessing { ProcessingView() }

                ZStack {
                    Rectangle()
                        .background(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(height: 90)
                        .cornerRadius(35)
                    
                    HStack(alignment: .center, spacing: 20) {
                        Button {
                            isMapTapped = true
                            isListTapped = false
                        } label: {
                            VStack(spacing: 0) {
                                Image("Map")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.primary)
                                    .frame(width: 24, height: 24)
                                
                                Text(LocalizedStringKey("Map"))
                                    .foregroundColor(.primary)
                                    .font(.system(.footnote))
                            }
                        }
                        
                        Button {
                            isMapTapped = false
                            isListTapped = true
                        } label: {
                            VStack(spacing: 0) {
                                Image("List")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.primary)
                                    .frame(width: 24, height: 24)
                                Text("Around you")
                                    .foregroundColor(.primary)
                                    .font(.system(.footnote))
                                    .lineLimit(1)
                            }
                        }
                        
                        Button {
                            chargersViewModel.loadChargers(with: locationViewModel.region.center)
                        } label: {
                            VStack(spacing: 0) {
                                Image("Search")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.primary)
                                    .frame(width: 24, height: 24)
                                Text("Find")
                                    .foregroundColor(.primary)
                                    .font(.system(.footnote))
                            }
                        }
                        .disabled(chargersViewModel.isProcessing)
                        
                        Button {
                            withAnimation {
                                isSheetPresented.toggle()
                                isFilterTapped.toggle()
                            }
                        } label: {
                            VStack(spacing: 0) {
                                Image("Filters")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.primary)
                                    .frame(width: 24, height: 24)
                                Text("Filters")
                                    .foregroundColor(.primary)
                                    .font(.system(.footnote))
                            }
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
            if let charger = charger {
                ChargerView(chargerViewModel: ChargerViewModel(charger: charger))
            }
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
                    .renderingMode(.template)
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
