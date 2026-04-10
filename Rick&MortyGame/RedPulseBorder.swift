//
//  RedPulseBorder.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI

struct RedPulseBorder: View {
    @Binding var isActive: Bool
    @Binding var isTrue: Bool

    @State private var glowRadius: CGFloat = 0
    @State private var opacity: Double = 0

    let appearTime = 0.28
    let delayTime = 0.35
    let dissapearTime = 0.28

    private var pulseColor: Color {
        isTrue ? RMTheme.portalMint : Color(red: 1, green: 0.32, blue: 0.38)
    }

    var body: some View {
        if isActive {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [pulseColor, pulseColor.opacity(0.45)]),
                        center: .center
                    ),
                    lineWidth: 26
                )
                .blur(radius: glowRadius)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: appearTime)) {
                        glowRadius = 42
                        opacity = 1.0
                    }

                    withAnimation(.easeIn(duration: dissapearTime).delay(delayTime)) {
                        opacity = 0
                    }
                }
        }
    }
}

extension View {
    func redPulseBorder(isActive: Binding<Bool>, isTrue: Binding<Bool>) -> some View {
        self.overlay(
            RedPulseBorder(isActive: isActive, isTrue: isTrue)
                .ignoresSafeArea()
        )
    }
}
