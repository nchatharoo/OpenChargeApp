//
//  OpenChargeAppApp.swift
//  OpenChargeApp
//
//  Created by Nadheer on 02/09/2021.
//  Updated to latest SwiftUI on 31/03/2025
//

import SwiftUI

@main
struct OpenChargeApp: App {
    @StateObject private var locationViewModel = LocationViewModel()
    @StateObject private var chargerViewModel = ChargersViewModel(client: URLSessionHTTPClient())
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationViewModel: locationViewModel, chargersViewModel: chargerViewModel)
                .environmentObject(locationViewModel)
                .environmentObject(chargerViewModel)
                .task {
                    // Initialize any app-wide tasks here if needed
                }
        }
    }
}
