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
    let config = AppConfiguration.share

    @State private var showPulse = false
    @State private var showGreenPulse = false
    
    var body: some View {
        ZStack {
            
            VStack{
                charactersCountView
                Spacer()
                characterImageView
                
                charactersTitleView
                Spacer()
                
                actionButtonsView.padding(.top, 20)
                
            }.redPulseBorder(isActive: $showPulse, isTrue: $showGreenPulse)
                .onChange(of: viewModel.points) {o, v in
                    config.points = v
                }
        }
    }
    
    
    var charactersCountView: some View {
        VStack {
            if config.characterCount > 0 {
                Text("Opened Characters")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("\(config.characterCount) / \(AppConfiguration.maxCharacterCount)")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }.padding(.bottom)
    }
    var charactersTitleView: some View {
        VStack {
            if let ch = viewModel.character {
                if let name = ch.getFrom?.displayEpisode ?? ch.getFrom {
                    Text("From pack: \(name)")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Text(ch.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.primary)
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    var characterImageView: some View {
        VStack {
            if let char = viewModel.character {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background( RoundedRectangle(cornerRadius: 12).stroke(Color(.systemCyan), lineWidth: 12))
                    .overlay {
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
                    .frame(width: 200, height: 200)
                    .padding(.horizontal)
            }
        }
    }
    
    var actionButtonsView: some View {
        VStack {
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
        }
    }
    
        
    private func triggerRedPulse(isTrue: Bool) {
        showPulse = true
        showGreenPulse = isTrue
        
        // Auto hide after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPulse = false
        }
    }
}




