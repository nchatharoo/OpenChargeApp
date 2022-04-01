//
//  ContentView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//
import MapKit
import SwiftUI

struct WaveFill: Shape {
    
    // MARK:- variables
    var curve: CGFloat
    let curveHeight: CGFloat
    let curveLength: CGFloat
    
    // MARK:- functions
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width, y: rect.height * 2))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 2))
        
        for i in stride(from: 0, to: CGFloat(rect.width), by: 1) {
            path.addLine(to: CGPoint(x: i, y: sin(((i / rect.height) + curve) * curveLength * .pi) * curveHeight + rect.midY))
        }
        path.addLine(to: CGPoint(x: rect.width, y:  rect.height * 2))
        return path
    }
}



struct WaveFill_Previews: PreviewProvider {
    static var previews: some View {
        WaveFill(curve: 1, curveHeight: 4, curveLength: 3)
            .fill(Color.orange.opacity(0.5))
            .opacity(0.5)
            .frame(width: 200, height: 100)
            .offset(y: 140)
    }
}

struct MyCustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.55166*width, y: 0.26317*height))
        path.addCurve(to: CGPoint(x: 0.56281*width, y: 0.28003*height), control1: CGPoint(x: 0.55842*width, y: 0.26605*height), control2: CGPoint(x: 0.56281*width, y: 0.27269*height))
        path.addLine(to: CGPoint(x: 0.56281*width, y: 0.45107*height))
        path.addLine(to: CGPoint(x: 0.65886*width, y: 0.45107*height))
        path.addCurve(to: CGPoint(x: 0.6747*width, y: 0.46017*height), control1: CGPoint(x: 0.66538*width, y: 0.45107*height), control2: CGPoint(x: 0.67141*width, y: 0.45453*height))
        path.addCurve(to: CGPoint(x: 0.67482*width, y: 0.47842*height), control1: CGPoint(x: 0.67798*width, y: 0.46579*height), control2: CGPoint(x: 0.67803*width, y: 0.47275*height))
        path.addLine(to: CGPoint(x: 0.6628*width, y: 0.49971*height))
        path.addCurve(to: CGPoint(x: 0.49048*width, y: 0.71581*height), control1: CGPoint(x: 0.61719*width, y: 0.58043*height), control2: CGPoint(x: 0.55902*width, y: 0.65337*height))
        path.addLine(to: CGPoint(x: 0.47104*width, y: 0.73352*height))
        path.addCurve(to: CGPoint(x: 0.45129*width, y: 0.73673*height), control1: CGPoint(x: 0.46567*width, y: 0.73841*height), control2: CGPoint(x: 0.45793*width, y: 0.73967*height))
        path.addCurve(to: CGPoint(x: 0.44036*width, y: 0.71997*height), control1: CGPoint(x: 0.44465*width, y: 0.7338*height), control2: CGPoint(x: 0.44036*width, y: 0.72722*height))
        path.addLine(to: CGPoint(x: 0.44036*width, y: 0.55038*height))
        path.addLine(to: CGPoint(x: 0.34114*width, y: 0.55038*height))
        path.addCurve(to: CGPoint(x: 0.3228*width, y: 0.53205*height), control1: CGPoint(x: 0.33101*width, y: 0.55038*height), control2: CGPoint(x: 0.3228*width, y: 0.54217*height))
        path.addCurve(to: CGPoint(x: 0.32517*width, y: 0.52302*height), control1: CGPoint(x: 0.3228*width, y: 0.52877*height), control2: CGPoint(x: 0.32367*width, y: 0.52569*height))
        path.addCurve(to: CGPoint(x: 0.48832*width, y: 0.3086*height), control1: CGPoint(x: 0.36816*width, y: 0.44356*height), control2: CGPoint(x: 0.42319*width, y: 0.37123*height))
        path.addLine(to: CGPoint(x: 0.53178*width, y: 0.26682*height))
        path.addCurve(to: CGPoint(x: 0.55166*width, y: 0.26317*height), control1: CGPoint(x: 0.53707*width, y: 0.26173*height), control2: CGPoint(x: 0.5449*width, y: 0.26029*height))
        path.addLine(to: CGPoint(x: 0.55166*width, y: 0.26317*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.37253*width, y: 0.51372*height))
        path.addLine(to: CGPoint(x: 0.4587*width, y: 0.51372*height))
        path.addCurve(to: CGPoint(x: 0.47703*width, y: 0.53205*height), control1: CGPoint(x: 0.46882*width, y: 0.51372*height), control2: CGPoint(x: 0.47703*width, y: 0.52192*height))
        path.addLine(to: CGPoint(x: 0.47703*width, y: 0.67828*height))
        path.addCurve(to: CGPoint(x: 0.62742*width, y: 0.48773*height), control1: CGPoint(x: 0.53614*width, y: 0.62242*height), control2: CGPoint(x: 0.58681*width, y: 0.55823*height))
        path.addLine(to: CGPoint(x: 0.54448*width, y: 0.48773*height))
        path.addCurve(to: CGPoint(x: 0.52615*width, y: 0.4694*height), control1: CGPoint(x: 0.53436*width, y: 0.48773*height), control2: CGPoint(x: 0.52615*width, y: 0.47953*height))
        path.addLine(to: CGPoint(x: 0.52615*width, y: 0.32309*height))
        path.addLine(to: CGPoint(x: 0.51373*width, y: 0.33503*height))
        path.addCurve(to: CGPoint(x: 0.37253*width, y: 0.51372*height), control1: CGPoint(x: 0.45872*width, y: 0.38792*height), control2: CGPoint(x: 0.41123*width, y: 0.44805*height))
        path.addLine(to: CGPoint(x: 0.37253*width, y: 0.51372*height))
        path.closeSubpath()
        return path
    }
}
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
                    .navigationTitle("Charging stations")
                }
                .opacity(isListTapped ? 1 : 0)
                .animation(.spring(), value: isListTapped)
            }
            
            VStack {
                if chargersViewModel.isProcessing { ProcessingView() }
                MyCustomShape()

                ZStack {
                    Rectangle()
                        .background(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(height: 90)
                        .cornerRadius(35)
                    
                    HStack(spacing: 60) {
                        Button {
                            isMapTapped = true
                            isListTapped = false
                        } label: {
                            Image("Map")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.primary)
                                .frame(width: 24, height: 24)
                        }
                        
                        Button {
                            isMapTapped = false
                            isListTapped = true
                        } label: {
                            Image("List")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.primary)
                                .frame(width: 24, height: 24)
                        }
                        
                        Button {
                            chargersViewModel.loadChargers(with: locationViewModel.region.center)
                        } label: {
                            Image("Search")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.primary)
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
                                .renderingMode(.template)
                                .foregroundColor(.primary)
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
