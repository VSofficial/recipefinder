//
//  TooltipModifier.swift
//  recipefinder
//
//  Created by Varun Sharma on 14/07/26.
//


import SwiftUI

struct TooltipModifier: ViewModifier {
    let text: String
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isShowing.toggle()
                }
            }
            .overlay(alignment: .top) {
                if isShowing {
                    Text(text)
                        .font(.caption.pointSize(20))
                        
                        
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                        .fixedSize()
                        .offset(y: -32)
                        .zIndex(1)
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            }
    }
}

extension View {
    func tooltip(_ text: String) -> some View {
        self.modifier(TooltipModifier(text: text))
    }
}
