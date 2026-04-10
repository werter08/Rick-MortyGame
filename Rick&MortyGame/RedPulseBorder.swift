//
//  RedPulseBorder.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//


import SwiftUI
import CoreData

struct RedPulseBorder: View {
    @Binding var isActive: Bool
    @Binding var isTrue: Bool
    
    @State private var glowRadius: CGFloat = 0
    @State private var opacity: Double = 0
    
    let appearTime = 0.3
    let delayTime = 0.4
    let dissapearTime = 0.3
    
    var body: some View {
        if isActive {
            RoundedRectangle(cornerRadius: 48)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: !isTrue ? [.red, .red] : [.green, .green]),
                        center: .center
                    ),
                    lineWidth: 32
                )
                .blur(radius: glowRadius)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: appearTime)) {
                        glowRadius = 45
                        opacity = 1.0
                    }
                    
                    // Fade out and reset after pulse
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
