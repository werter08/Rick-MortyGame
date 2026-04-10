//
//  ShopView.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var viewModel: ViewModel
    let config = AppConfiguration.share

    @State private var showResult = false
    @State private var showLocationAlert = false
    @State private var showEpisodeAlert = false

    var body: some View {
        ZStack {
            RMTheme.screenBackground

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Interdimensional shop")
                            .font(.title2.weight(.heavy))
                        Text("Spend points to unlock random episodes and locations — new characters join your collection.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 4)

                    GlassCard {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [RMTheme.portalMint.opacity(0.35), RMTheme.portalCyan.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 52, height: 52)
                                Image(systemName: "star.leadinghalf.filled")
                                    .font(.title2)
                                    .foregroundStyle(RMTheme.portalMint)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Your points")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                Text("\(config.points)")
                                    .font(.title.weight(.heavy).monospacedDigit())
                            }
                            Spacer()
                        }
                        .padding(18)
                    }

                    Text("Unlock packs")
                        .font(.headline.weight(.semibold))
                        .padding(.top, 4)

                    VStack(spacing: 16) {
                        shopRow(
                            title: "Random episode",
                            subtitle: "Pull every character listed in one episode",
                            icon: "tv.fill",
                            cost: config.episodeCost,
                            gradient: [Color.green.opacity(0.85), Color.mint.opacity(0.65)],
                            canAfford: config.points >= config.episodeCost,
                            action: { showEpisodeAlert = true }
                        )

                        shopRow(
                            title: "Random location",
                            subtitle: "Residents from a dimension or named place",
                            icon: "globe.americas.fill",
                            cost: config.locationCost,
                            gradient: [RMTheme.portalCyan.opacity(0.9), RMTheme.portalViolet.opacity(0.75)],
                            canAfford: config.points >= config.locationCost,
                            action: { showLocationAlert = true }
                        )
                    }

                    if viewModel.isLoading {
                        HStack(spacing: 10) {
                            ProgressView()
                                .tint(RMTheme.portalCyan)
                            Text("Opening portal…")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
        }
        .alert("Buy episode pack?", isPresented: $showEpisodeAlert) {
            Button("Cancel", role: .cancel) { showEpisodeAlert = false }
            Button("Buy for \(config.episodeCost) pts") {
                viewModel.buyRandomEpisode()
                showEpisodeAlert = false
            }
        } message: {
            Text("A random unseen episode will be added to your collection. Cost increases by 4 after each purchase.")
        }
        .alert("Buy location pack?", isPresented: $showLocationAlert) {
            Button("Cancel", role: .cancel) { showLocationAlert = false }
            Button("Buy for \(config.locationCost) pts") {
                viewModel.buyRandomLocation()
                showLocationAlert = false
            }
        } message: {
            Text("A random unseen location will be added. Cost increases by 2 after each purchase.")
        }
        .onChange(of: viewModel.allFetched) { _, newValue in
            if newValue {
                showResult = true
            }
        }
        .alert("Pack opened", isPresented: $showResult) {
            Button("Nice", role: .cancel) {
                showResult = false
            }
        } message: {
            Text(resultMessage)
        }
    }

    private var resultMessage: String {
        let added = config.characterCount - viewModel.charsBeforeFetching
        return "\(viewModel.fetchedCardName)\n\nCharacters in this pack: \(viewModel.ChactersInFetch)\nAdded to your collection: \(added)"
    }

    private func shopRow(
        title: String,
        subtitle: String,
        icon: String,
        cost: Int,
        gradient: [Color],
        canAfford: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(RMTheme.portalMint)
                        Text("\(cost) points")
                            .font(.subheadline.weight(.bold).monospacedDigit())
                            .foregroundStyle(canAfford ? RMTheme.portalMint : Color.orange.opacity(0.9))
                    }
                    .padding(.top, 4)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
            }
            .padding(18)
            .background {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    }
            }
            .opacity(canAfford ? 1 : 0.45)
        }
        .buttonStyle(.plain)
        .disabled(!canAfford || viewModel.isLoading)
    }
}
