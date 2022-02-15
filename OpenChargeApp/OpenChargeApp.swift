//
//  OpenChargeAppApp.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//

import SwiftUI

@main
struct OpenChargeApp: App {
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var openchargeViewModel = ChargePointViewModel(client: URLSessionHTTPClient())
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationViewModel: locationViewModel, openchargeViewModel: openchargeViewModel)
        }
    }
}
