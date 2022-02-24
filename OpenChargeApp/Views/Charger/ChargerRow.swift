//
//  ChargerRow.swift
//  OpenChargeApp
//
//  Created by Nadheer on 24/02/2022.
//

import SwiftUI

struct ChargerRow: View {
    let charger: Charger

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                ChargerAnnotationView(levelID: charger.connections?.first?.levelID ?? 0)
            }

            VStack(alignment: .leading) {
                Text("\(charger.addressInfo?.title ?? "")")
                    .fontWeight(.semibold)
                Text("\(charger.addressInfo?.distance ?? 0.0, specifier: "%.2f") km")
                    .font(.callout)
            }
            Spacer()
            Image("Caret")
        }
        .foregroundColor(Color.primary)
    }
}
