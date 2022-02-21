//
//  BottomSheetView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/02/2022.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content
    
    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var indicator: some View {
        RoundedRectangle(cornerRadius: Constants.radius)
            .opacity(0.5)
            .frame(
                width: Constants.indicatorWidth,
                height: Constants.indicatorHeight)
            .onTapGesture {
                withAnimation {
                    self.isOpen.toggle()
                }
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator
                    .padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(.ultraThinMaterial)
            .cornerRadius(Constants.radius, corners: [.topLeft, .topRight])
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    withAnimation {
                        self.isOpen = value.translation.height < 0
                    }
                }
            )
            .shadow(color: Color.primary.opacity(0.1), radius: 5)
        }
    }
}
