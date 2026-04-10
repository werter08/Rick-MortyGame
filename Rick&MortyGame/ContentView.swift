//
//  ContentView.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        TabView {
            GameView()
                .tabItem {
                    Label("Play", systemImage: "sparkles.tv")
                }
            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "square.stack.fill")
                }
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "cart.fill")
                }
        }
        .environmentObject(viewModel)
        .tint(RMTheme.portalCyan)
        .preferredColorScheme(.dark)
    }
}
