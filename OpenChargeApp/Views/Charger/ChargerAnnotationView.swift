//
//  PlaceAnnotationView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 15/02/2022.
//

import SwiftUI

struct ChargerAnnotationView: View {
    let levelID: Int
    @State private var isPressed: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Image("Status")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(2)
                .background(
                    ZStack {
                        Circle()
                            .stroke(chargerColor(for: levelID).opacity(0.2), lineWidth: 1)
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                    }
                )
                .foregroundColor(chargerColor(for: levelID))
        }
    }
    
    private func chargerColor(for levelID: Int) -> Color {
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
