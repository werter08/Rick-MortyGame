//
//  ContentView.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI
import CoreData

struct ShopView: View {
    @EnvironmentObject var viewModel: ViewModel
    let config = AppConfiguration.share

    @State private var showResult = false
    @State private var showLocationAlert = false
    @State private var showEpisodeAlert = false
    
    var body: some View {
        VStack {
            Button {
                showEpisodeAlert = true
            } label: {
                VStack {
                    Text("Random Episode for")
                    Text("\(config.episodeCost)")
                }.frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(.capsule)
                    .padding()
                    .disabled(config.points < config.episodeCost)
                    
            }
            
            Button {
                showLocationAlert = true
            } label: {
                VStack {
                    Text("Random Location for")
                    Text("\(config.locationCost)")
                }.frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(.capsule)
                    .padding()
                    .disabled(config.points < config.locationCost)

            }
        }
        .alert("Want To Buy Episode For \(config.episodeCost) Points?", isPresented: $showEpisodeAlert) {
            Button {
                 showEpisodeAlert = false
            } label: {
                Text("No")
            }
            
            Button {
                viewModel.buyRandomEpisode()
                showEpisodeAlert = false
            } label: {
                Text("Yes")
            }
        }
        .alert("Want To Buy Location For \(config.locationCost) Points?", isPresented: $showLocationAlert) {
            Button {
                 showLocationAlert = false
            } label: {
                Text("No")
            }
            
            Button {
                viewModel.buyRandomLocation()
                showLocationAlert = false

            } label: {
                Text("Yes")
            }
        }.onChange(of: viewModel.allFetched) { o, newValue in
            if newValue {
                showResult = true
            }
        }
        .alert("RESULT: \(viewModel.fetchedCardName)", isPresented: $showResult) {
            Text("Cards count in new deck: \(viewModel.ChactersInFetch)")
            Text("Cards added: \(config.characterCount - viewModel.charsBeforeFetching)")
            Button {
                showResult = false
            } label: {
                Text("OK")
            }
        }
    }
    
    
}




