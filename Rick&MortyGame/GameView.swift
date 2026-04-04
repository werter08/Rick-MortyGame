//
//  ContentView.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI
import CoreData

struct GameView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var showPulse = false
    @State private var showGreenPulse = false
    
    var body: some View {
        ZStack {
            VStack{
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background( RoundedRectangle(cornerRadius: 12).stroke(Color(.systemCyan), lineWidth: 12))
                    .overlay {
                        if let char = viewModel.character {
                            AsyncImage(
                                url: URL(string: char.image),
                                transaction: Transaction(animation: .easeInOut(duration: 0.2))
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
                    .padding(.horizontal)
                
                Text(viewModel.character?.name ?? "No Name Yet" )
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.primary)
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                
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
                        .padding(.vertical, 40)
                    
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
                         
                        Spacer()
                        if viewModel.points != -1 {
                            Text("Current Points: \(viewModel.points)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(showPulse ? showGreenPulse ? Color.green : Color.red : Color.primary)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        Button {
                            viewModel.getRandomChar()
                        } label: {
                            Text("Skip")
                                .font(.system(size:26, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }.frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(.capsule)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 20)
                    }
                }
            }.redPulseBorder(isActive: $showPulse, isTrue: $showGreenPulse)
        }
    }
    
        
    private func triggerRedPulse(isTrue: Bool) {
        showPulse = true
        showGreenPulse = isTrue
        
        // Auto hide after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            showPulse = false
        }
    }
}




