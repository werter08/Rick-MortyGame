//
//  GameView.swift
//  Rick&MortyGame
//
//  Created by Begench Yangibayev on 31.03.2026.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: ViewModel
    @ObservedObject private var config = AppConfiguration.share

    @State private var showPulse = false
    @State private var showGreenPulse = false

    var body: some View {
        ZStack {
            RMTheme.screenBackground

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                Spacer(minLength: 12)

                characterCardSection
                    .padding(.horizontal, 20)

                Spacer(minLength: 12)

                nameSection
                    .padding(.horizontal, 20)

                Spacer(minLength: 8)

                actionButtonsView
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
            .redPulseBorder(isActive: $showPulse, isTrue: $showGreenPulse)
        }
        .onChange(of: viewModel.points) { _, v in
            config.points = v
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Collection")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                if config.characterCount > 0 {
                    HStack(spacing: 8) {
                        Image(systemName: "person.3.fill")
                            .foregroundStyle(RMTheme.portalMint)
                        Text("\(config.characterCount)")
                            .font(.title2.weight(.heavy).monospacedDigit())
                        Text("/ \(AppConfiguration.maxCharacterCount)")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Open packs in Shop")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 14) {
                    Label {
                        Text("\(config.EpisodeCount)/\(AppConfiguration.maxEpisodeCount)")
                            .font(.caption.weight(.semibold).monospacedDigit())
                    } icon: {
                        Image(systemName: "tv.fill")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.green.opacity(0.95))

                    Label {
                        Text("\(config.LocaionCount)/\(AppConfiguration.maxLocationCount)")
                            .font(.caption.weight(.semibold).monospacedDigit())
                    } icon: {
                        Image(systemName: "globe.americas.fill")
                            .font(.caption)
                    }
                    .foregroundStyle(RMTheme.portalCyan.opacity(0.95))
                }
                .accessibilityElement(children: .combine)
            }
            Spacer()
            pointsChip
        }
    }

    private var pointsChip: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundStyle(RMTheme.portalMint)
            Text("\(viewModel.points)")
                .font(.headline.weight(.bold).monospacedDigit())
                .foregroundStyle(showPulse ? (showGreenPulse ? RMTheme.portalMint : Color.red.opacity(0.95)) : Color.primary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background {
            Capsule()
                .fill(Color.white.opacity(0.08))
                .overlay {
                    Capsule()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                }
        }
    }

    private var characterCardSection: some View {
        Group {
            if let char = viewModel.character {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    RMTheme.portalCyan.opacity(0.35),
                                    RMTheme.portalViolet.opacity(0.25)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blur(radius: 18)
                        .padding(-8)

                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(red: 0.1, green: 0.11, blue: 0.16))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            RMTheme.portalCyan.opacity(0.9),
                                            RMTheme.portalViolet.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        }
                        .shadow(color: RMTheme.portalCyan.opacity(0.25), radius: 16, y: 8)

                    AsyncImage(
                        url: URL(string: char.image),
                        transaction: Transaction(animation: .easeInOut(duration: 0.25))
                    ) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(RMTheme.portalCyan)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            VStack(spacing: 8) {
                                Image(systemName: "wifi.exclamationmark")
                                    .font(.largeTitle)
                                Text("Image failed")
                                    .font(.caption)
                            }
                            .foregroundStyle(.secondary)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .frame(height: 240)
            }
        }
    }

    private var nameSection: some View {
        VStack(spacing: 8) {
            if let ch = viewModel.character {
                if let pack = ch.getFrom?.displayEpisode ?? ch.getFrom {
                    HStack(spacing: 6) {
                        Image(systemName: "shippingbox.fill")
                            .font(.caption)
                            .foregroundStyle(RMTheme.portalCyan)
                        Text(pack)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                Text(ch.name)
                    .font(.title2.weight(.heavy))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var actionButtonsView: some View {
        VStack(spacing: 14) {
            if viewModel.points == -1 {
                Button {
                    viewModel.getRandomChar()
                } label: {
                    Label("Start guessing", systemImage: "play.fill")
                        .font(.headline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(PortalButtonStyle(accent: RMTheme.portalCyan))
                .padding(.horizontal, 8)
            } else {
                VStack(spacing: 10) {
                    Text("Guess status")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 4)

                    HStack(spacing: 10) {
                        ForEach(CStatus.allCases, id: \.rawValue) { status in
                            statusButton(status)
                        }
                    }

                    Button {
                        viewModel.getRandomChar()
                    } label: {
                        Label("Skip", systemImage: "forward.fill")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .buttonStyle(PortalButtonStyle(accent: Color.white.opacity(0.18), foreground: .primary))
                }
            }
        }
    }

    private func statusButton(_ status: CStatus) -> some View {
        Button {
            viewModel.selectedStatus(status: status) { isCorrect in
                triggerRedPulse(isTrue: isCorrect)
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: status.iconName)
                    .font(.title3.weight(.semibold))
                Text(status.rawValue)
                    .font(.caption2.weight(.bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(StatusPillStyle(color: status.color))
    }

    private func triggerRedPulse(isTrue: Bool) {
        showPulse = true
        showGreenPulse = isTrue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPulse = false
        }
    }
}

private struct PortalButtonStyle: ButtonStyle {
    var accent: Color
    var foreground: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(accent.opacity(configuration.isPressed ? 0.85 : 1))
                    .shadow(color: accent.opacity(0.35), radius: configuration.isPressed ? 4 : 12, y: 6)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

private struct StatusPillStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.95), color.opacity(0.65)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    }
            }
            .shadow(color: color.opacity(0.35), radius: configuration.isPressed ? 2 : 8, y: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private extension CStatus {
    var iconName: String {
        switch self {
        case .alive: return "heart.fill"
        case .dead: return "xmark.circle.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}
