//
//  Theme.swift
//  Rick&MortyGame
//

import SwiftUI

enum RMTheme {
    static let portalMint = Color(red: 0.35, green: 0.92, blue: 0.62)
    static let portalCyan = Color(red: 0.25, green: 0.78, blue: 0.98)
    static let portalViolet = Color(red: 0.55, green: 0.35, blue: 0.95)
    static let deepSpaceTop = Color(red: 0.04, green: 0.05, blue: 0.12)
    static let deepSpaceBottom = Color(red: 0.07, green: 0.04, blue: 0.14)

    static var screenBackground: some View {
        ZStack {
            LinearGradient(
                colors: [deepSpaceTop, deepSpaceBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            StarfieldView()
                .opacity(0.55)
            RadialGradient(
                colors: [
                    portalViolet.opacity(0.22),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 20,
                endRadius: 420
            )
            RadialGradient(
                colors: [
                    portalCyan.opacity(0.12),
                    Color.clear
                ],
                center: .bottomLeading,
                startRadius: 10,
                endRadius: 380
            )
        }
        .ignoresSafeArea()
    }
}

private struct StarfieldView: View {
    var body: some View {
        Canvas { context, size in
            for i in 0..<140 {
                let x = pseudoRandom(i, 1) * size.width
                let y = pseudoRandom(i, 3) * size.height
                let r = 0.4 + pseudoRandom(i, 5) * 1.2
                let o = 0.15 + pseudoRandom(i, 7) * 0.85
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: r, height: r)),
                    with: .color(.white.opacity(o))
                )
            }
        }
    }

    private func pseudoRandom(_ i: Int, _ salt: Int) -> CGFloat {
        let v = sin(Double(i * salt * 17 + 42)) * 43758.5453
        return CGFloat(v - floor(v))
    }
}

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 22
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        RMTheme.portalCyan.opacity(0.45),
                                        RMTheme.portalViolet.opacity(0.35)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
            }
            .shadow(color: RMTheme.portalCyan.opacity(0.12), radius: 20, y: 10)
    }
}
