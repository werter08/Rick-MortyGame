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
    
    @State private var showPulse = false
    @State private var showGreenPulse = false
    
    var body: some View {
        VStack {
            Text("SHOP")
        }
    }
    
}




