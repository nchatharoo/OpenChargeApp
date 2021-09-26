//
//  OpenChargeAppApp.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import SwiftUI

@main
struct OpenChargeAppApp: App {
    @ObservedObject private var locationViewModel = LocationViewModel(locationManager: LocationManager())
    @ObservedObject private var openchargeViewModel = OpenChargeViewModel(openchargeloader: OpenChargeLoader(client: URLSessionHTTPClient()))
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
        }
    }
}
