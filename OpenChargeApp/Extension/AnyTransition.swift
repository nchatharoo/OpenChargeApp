//
//  AnyTransition.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/02/2022.
//

import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).animation(.linear(duration: 0.3)),
            removal: .move(edge: .bottom).animation(.linear(duration: 0.3))
        )
        .combined(with: .opacity)
    }
}
