//
//  ProcessingView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 15/02/2022.
//

import SwiftUI

struct ProcessingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(2)
                .padding()
            Text("Processing...")
                .foregroundColor(.white)
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.black.opacity(0.9)))
    }
}
