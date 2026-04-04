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
    
    var body: some View {
        TabView {
            GameView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "basket.fill")
                }
        }
        .environmentObject(viewModel)
    }
    
}



