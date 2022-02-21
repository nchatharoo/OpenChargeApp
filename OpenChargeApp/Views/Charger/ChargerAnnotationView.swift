//
//  PlaceAnnotationView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 15/02/2022.
//

import SwiftUI

struct ChargerAnnotationView: View {
    let levelID: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "bolt.circle.fill")
                .font(.title)
                .foregroundColor(chargerColor(for: levelID))
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(chargerColor(for: levelID))
                .offset(x: 0, y: -5)
        }
    }
    
    func chargerColor(for levelID: Int) -> Color {
        switch levelID {
        case 0:
            return .red
        case 1:
            return .gray
        case 2:
            return .green
        case 3:
            return .orange
        default:
            return .clear
        }
    }
}
