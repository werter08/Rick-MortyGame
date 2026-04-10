//
//  CollectionView.swift
//  Rick&MortyGame
//

import SwiftUI

struct CollectionView: View {
    @ObservedObject private var config = AppConfiguration.share

    var body: some View {
        ZStack {
            RMTheme.screenBackground

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    headerBlock

                    collectionSection(
                        title: "Episodes",
                        icon: "tv.fill",
                        tint: Color.green.opacity(0.85),
                        progress: config.EpisodeCount,
                        max: AppConfiguration.maxEpisodeCount,
                        items: config.episodeCollectionItems,
                        emptyMessage: "Unlock episodes in the Shop to add them here."
                    )

                    collectionSection(
                        title: "Locations",
                        icon: "globe.americas.fill",
                        tint: RMTheme.portalCyan,
                        progress: config.LocaionCount,
                        max: AppConfiguration.maxLocationCount,
                        items: config.locationCollectionItems,
                        emptyMessage: "Unlock locations in the Shop to add them here."
                    )
                }
                .padding(20)
                .padding(.bottom, 28)
            }
        }
    }

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Packs unlocked")
                .font(.title2.weight(.heavy))
            Text("Episodes and locations you have opened. Characters you pull appear on the Play tab.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            GlassCard {
                HStack(spacing: 0) {
                    summaryCell(
                        value: config.EpisodeCount,
                        max: AppConfiguration.maxEpisodeCount,
                        label: "Episodes",
                        icon: "tv.fill",
                        color: Color.green.opacity(0.9)
                    )
                    divider
                    summaryCell(
                        value: config.LocaionCount,
                        max: AppConfiguration.maxLocationCount,
                        label: "Locations",
                        icon: "mappin.and.ellipse",
                        color: RMTheme.portalCyan
                    )
                }
                .padding(.vertical, 6)
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(width: 1)
            .padding(.vertical, 12)
    }

    private func summaryCell(
        value: Int,
        max: Int,
        label: String,
        icon: String,
        color: Color
    ) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text("\(value) / \(max)")
                .font(.title3.weight(.heavy).monospacedDigit())
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private func collectionSection(
        title: String,
        icon: String,
        tint: Color,
        progress: Int,
        max: Int,
        items: [UnlockedPackRecord],
        emptyMessage: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.headline.weight(.bold))
                Spacer()
                Text("\(progress) / \(max)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            if items.isEmpty {
                Text(emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.05))
                    }
            } else {
                VStack(spacing: 0) {
                    ForEach(items) { item in
                        packRow(item: item, tint: tint, showDivider: item.id != items.last?.id)
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        }
                }
            }
        }
    }

    private func packRow(item: UnlockedPackRecord, tint: Color, showDivider: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Text("#\(item.apiId)")
                    .font(.caption.weight(.bold).monospacedDigit())
                    .foregroundStyle(.tertiary)
                    .frame(width: 44, alignment: .leading)

                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 8)

                Image(systemName: "checkmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(tint.opacity(0.9))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            if showDivider {
                Divider()
                    .overlay(Color.white.opacity(0.08))
                    .padding(.leading, 72)
            }
        }
    }
}
