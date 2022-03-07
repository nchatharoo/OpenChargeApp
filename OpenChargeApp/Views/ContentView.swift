//
//  ContentView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//
import MapKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var locationViewModel: LocationViewModel
    @ObservedObject var chargersViewModel: ChargersViewModel
    
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
                                        isSheetPresented = true
                                        isChargerTapped = true
                                    }
                                })
                        }
                    })
                }
                .opacity(isMapTapped ? 1 : 0)
                
            } else {
                NavigationView {
                    ScrollViewOffset {
                        if chargersViewModel.filteredChargePoints.isEmpty {
                            EmptyRowButton
                        }
                        ForEach(chargersViewModel.filteredChargePoints) { charger in
                            Button {
                                self.charger = charger
                                withAnimation {
                                    isSheetPresented = true
                                    isChargerTapped = true
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
                .offset(y: isListTapped ? -scrollOffset : 0)
            }
            
            if isSheetPresented {
                GeometryReader { geometry in
                    BottomSheetView(isOpen: $isSheetPresented, maxHeight: geometry.size.height - 20) {
                        
                        if isChargerTapped {
                            ChargerScrollView(chargers:chargersViewModel.filteredChargePoints, charger: charger!)
                        }
                        
                        if isFilterTapped {
                            FilterView()
                                .environmentObject(chargersViewModel)
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
    
    var EmptyRowButton: some View {
        Button {
            chargersViewModel.loadChargePoints(with: locationViewModel.region.center)
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
    static var locationViewModel = LocationViewModel()
    static var openchargeViewModel = ChargersViewModel(client: URLSessionHTTPClient())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel, chargersViewModel: openchargeViewModel)
    }
}

struct FilterView: View {
    @EnvironmentObject var chargersViewModel: ChargersViewModel
    
    @State private var filters: ChargerFilter = ChargerFilter()
    
    @State private var powerKw: Double = 0
    @State private var selectedUsage: ChargerUsage = .all
    
    @State private var indexType: Int = 0

    var body: some View {
        VStack {
            Text("Select the desired power: \(powerKw, specifier: "%.1f")")
            HStack {
                Image(systemName: "bolt.circle.fill")
                    .font(.title)
                Slider(value: $powerKw, in: 0...650) {
                    Text("Power")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("650")
                } onEditingChanged: { _ in
                    filters.powerKW = powerKw
                }
                .accentColor(Color.green)
                Image(systemName: "bolt.circle.fill")
                    .font(.largeTitle)
            }
            Text("\(chargersViewModel.filteredChargePoints.count)")
                
            Picker("", selection: $selectedUsage) {
                Text("All").tag(ChargerUsage.all)
                Text("Pay at location").tag(ChargerUsage.isPayAtLocation)
                Text("Membership required").tag(ChargerUsage.isMembershipRequired)
                Text("Access key required").tag(ChargerUsage.isAccessKeyRequired)
            }
            .onChange(of: selectedUsage, perform: { newValue in
                filters.usageType = newValue
            })
            .pickerStyle(.segmented)
                                
            List {
                ForEach(Array(filters.connectionType.enumerated()), id: \.1) { (index, type) in
                    Button {
                        filters.connectionIndex = index
                    } label: {
                        Text(type)
                    }
                }
            }
        }
        .onChange(of: filters, perform: { newValue in
            chargersViewModel.filterCharger(with: filters)
        })
        .padding()
    }
}
