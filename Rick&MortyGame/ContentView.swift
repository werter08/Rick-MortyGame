//
//  ContentView.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    
    @State private var showPulse = false
    @State private var showGreenPulse = false
    
    var body: some View {
        ZStack {
            VStack{
                
                Text(viewModel.character?.name ?? "No Name Yet" )
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.primary)
                    .padding(.top)
                    .multilineTextAlignment(.center)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background( RoundedRectangle(cornerRadius: 12).stroke(Color(.systemCyan), lineWidth: 12))
                    .overlay {
                        if let char = viewModel.character {
                            AsyncImage(
                                url: URL(string: char.image),
                                transaction: Transaction(animation: .easeInOut(duration: 0.3))
                            ) { img in
                                switch img {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding(-12)
                                        .clipped()
                                        .cornerRadius(12)
                                        .transition(.opacity)
                                default: EmptyView()
                                }
                                
                            }
                        }
                    }
                    .frame(width: 300, height: 300)
                    .padding()
                
                if viewModel.points != -1 {
                    Text("Current Points: \(viewModel.points)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
                Spacer()
                
                if viewModel.points == -1 {
                    Button {
                        viewModel.getRandomChar()
                    } label: {
                        Text("Start")
                            .font(.system(size:26, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(.capsule)
                        .padding(.horizontal, 40)
                } else {
                    VStack {
                        ForEach(CStatus.allCases, id: \.rawValue) { c in
                            Button {
                                viewModel.selectedStatus(status: c) {
                                    triggerRedPulse(isTrue: $0)
                                }
                            } label: {
                                Text(c.rawValue)
                                    .font(.system(size:26, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }.frame(maxWidth: .infinity)
                                .background(c.color)
                                .clipShape(.capsule)
                                .padding(.horizontal, 40)
                        }
                    }
                }
            }.redPulseBorder(isActive: $showPulse, isTrue: $showGreenPulse)
        }
    }
    
        
    private func triggerRedPulse(isTrue: Bool) {
        showPulse = true
        showGreenPulse = isTrue
        
        // Auto hide after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            showPulse = false
        }
    }
}


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
                        gradient: Gradient(colors: !isTrue ? [.red, .orange, .red] : [.green, .cyan, .green]),
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
