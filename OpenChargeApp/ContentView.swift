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
    
    var body: some View {
        Map(coordinateRegion: $locationViewModel.coordinateRegion, showsUserLocation: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var locationViewModel = LocationViewModel(locationManager: LocationManager())
    static var previews: some View {
        ContentView(locationViewModel: locationViewModel)
    }
}
