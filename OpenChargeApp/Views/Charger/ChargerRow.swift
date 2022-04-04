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
            ChargerAnnotationView(levelID: charger.connections?.first?.levelID ?? 0)

            VStack(alignment: .leading) {
                Text("\(charger.addressInfo?.title ?? "")")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(charger.addressInfo?.distance ?? 0.0, specifier: "%.2f") km")
                    .font(.system(.callout))
            }
            Spacer()
            Image("Caret")
                .renderingMode(.template)
        }
        .foregroundColor(Color.primary)
        .padding(10)
    }
}
