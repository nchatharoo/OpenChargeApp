//
//  PlaceAnnotationView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 15/02/2022.
//

import SwiftUI

struct PlaceAnnotationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "bolt.circle.fill")
                .font(.title)
                .foregroundColor(.green)
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.green)
                .offset(x: 0, y: -5)
        }
    }
}
