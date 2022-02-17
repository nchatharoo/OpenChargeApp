//
//  BottomBarView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/02/2022.
//

import SwiftUI

struct BottomBarView: View {
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 90)
                    .cornerRadius(35)
                
                HStack(spacing: 85) {
                    Image(systemName: "map.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Divider()
                        .frame(height: 36)

                    Image(systemName: "list.bullet")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .shadow(color: Color.primary.opacity(0.1), radius: 5)
            .padding()
    }
}
