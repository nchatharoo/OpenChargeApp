//
//  OpenChargeAppApp.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import SwiftUI

@main
struct OpenChargeAppApp: App {
    @StateObject private var locationViewModel = LocationViewModel(locationManager: LocationManager())
    @StateObject private var openchargeViewModel = OpenChargeViewModel(openchargeloader: OpenChargeLoader(client: URLSessionHTTPClient()))
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
        }
    }
}
