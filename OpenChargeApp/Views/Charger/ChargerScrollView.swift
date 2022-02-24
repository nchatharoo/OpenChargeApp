//
//  ChargerScrollView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 21/02/2022.
//

import SwiftUI

struct ChargerScrollView: View {
    let chargers: [Charger]
    let charger: Charger
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 40) {
                    ForEach(chargers, id: \.id) { charger in
                        ChargerView(chargerViewModel: ChargerViewModel(charger: charger))
                    }
                    .onAppear {
                        scrollView.scrollTo(charger.id, anchor: .center)
                    }
                }
            }
        }
    }
}
