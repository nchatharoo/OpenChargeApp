//
//  SearchBarView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 11/02/2022.
//

import SwiftUI

struct SearchBarView: View {
    fileprivate let defaultRadius: CGFloat = 25
    fileprivate let placeholder: String = "Search location"
    fileprivate let magnifyingglass = Image(systemName: "magnifyingglass")
    fileprivate let close = Image(systemName: "xmark")
    @State private var query = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                        .fill(Color.white)
                        .frame(width: isFocused ? proxy.size.width : proxy.size.width / 1.7, height: 40, alignment: .center)
                        .animation(Animation.linear(duration: 0.3), value: isFocused)
                        .cornerRadius(defaultRadius, corners: [.topRight, .bottomRight])
                
                HStack {
                    magnifyingglass
                        .foregroundColor(.secondary)
                        .imageScale(.large)
                        .padding(.leading)

                    TextField(placeholder, text: $query)
                        .focused($isFocused)
                        .onTapGesture {
                            isFocused.toggle()
                        }
                        .onChange(of: query, perform: { value in
                            query = value
                        })
                    
                    close
                        .opacity(isFocused ? 1 : 0)
                        .foregroundColor(.secondary)
                        .imageScale(.large)
                        .padding(.trailing)
                        .onTapGesture {
                            isFocused = false
                            query = ""
                        }
                }
            }
        }
    }
}
