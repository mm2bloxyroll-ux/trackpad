//
//  GlassTheme.swift
//  TrackWeight
//

import SwiftUI

enum AppLayout {
    static let windowMinWidth: CGFloat = 720
    static let windowMinHeight: CGFloat = 580
    static let defaultWidth: CGFloat = 760
    static let defaultHeight: CGFloat = 600

    static let screenInset: CGFloat = 20
    static let panelPadding: CGFloat = 32
    static let sectionSpacing: CGFloat = 24
    static let footerMinHeight: CGFloat = 72
}

enum AppTheme {
    static let accent = LinearGradient(
        colors: [
            Color(red: 0.35, green: 0.55, blue: 1.0),
            Color(red: 0.25, green: 0.78, blue: 0.92),
            Color(red: 0.45, green: 0.92, blue: 0.88)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentColors: [Color] = [
        Color(red: 0.35, green: 0.55, blue: 1.0),
        Color(red: 0.25, green: 0.78, blue: 0.92),
        Color(red: 0.45, green: 0.92, blue: 0.88)
    ]

    static let warmAccent = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.55, blue: 0.35),
            Color(red: 1.0, green: 0.72, blue: 0.4)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Background

struct GlassBackground: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.09, blue: 0.18),
                    Color(red: 0.10, green: 0.14, blue: 0.28),
                    Color(red: 0.08, green: 0.20, blue: 0.26)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.cyan.opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 280
                    )
                )
                .frame(width: 520, height: 520)
                .offset(x: -180 + phase * 40, y: -120)
                .blur(radius: 2)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.4),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 320
                    )
                )
                .frame(width: 600, height: 600)
                .offset(x: 220 - phase * 30, y: 180)
                .blur(radius: 4)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.25),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 240
                    )
                )
                .frame(width: 400, height: 400)
                .offset(x: 60, y: 280 - phase * 20)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                phase = 1
            }
        }
    }
}

// MARK: - Modifiers

struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var tint: Color = .white
    var borderWidth: CGFloat = 1.5
    var borderTint: Color? = nil

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let accent = borderTint ?? .white

        content
            .background {
                shape
                    .fill(.ultraThinMaterial)
                    .background(
                        shape.fill(tint.opacity(0.08))
                    )
                    .overlay(
                        shape.stroke(accent.opacity(0.22), lineWidth: borderWidth + 0.5)
                    )
                    .overlay(
                        shape.stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.72),
                                    Color.white.opacity(0.18),
                                    accent.opacity(0.35)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: borderWidth
                        )
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 24, x: 0, y: 14)
            }
    }
}

/// Full-screen inset panel with a visible border matching the window content area.
struct GlassScreenFrame<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 22, style: .continuous)

        content()
            .padding(AppLayout.panelPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background {
                shape
                    .fill(.ultraThinMaterial.opacity(0.65))
                    .background(shape.fill(Color.white.opacity(0.04)))
                    .overlay(
                        shape.stroke(Color.white.opacity(0.28), lineWidth: 2)
                    )
                    .overlay(
                        shape.stroke(
                            LinearGradient(
                                colors: [
                                    Color.cyan.opacity(0.45),
                                    Color.white.opacity(0.12),
                                    Color.blue.opacity(0.25)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                    )
                    .shadow(color: Color.black.opacity(0.35), radius: 28, x: 0, y: 16)
            }
            .padding(AppLayout.screenInset)
    }
}

struct GlassFooterBar<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .frame(minHeight: AppLayout.footerMinHeight)
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .background(alignment: .top) {
                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
    }
}

struct GlassPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .background {
                Capsule()
                    .fill(AppTheme.accent)
                    .overlay(
                        Capsule()
                            .fill(Color.black.opacity(configuration.isPressed ? 0.15 : 0))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.cyan.opacity(0.35), radius: configuration.isPressed ? 6 : 14, x: 0, y: configuration.isPressed ? 2 : 8)
            }
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct AccentGradientText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(AppTheme.accent)
    }
}

extension View {
    func glassCard(
        cornerRadius: CGFloat = 20,
        tint: Color = .white,
        borderWidth: CGFloat = 1.5,
        borderTint: Color? = nil
    ) -> some View {
        modifier(GlassCardModifier(
            cornerRadius: cornerRadius,
            tint: tint,
            borderWidth: borderWidth,
            borderTint: borderTint
        ))
    }

    func appGlassBackground() -> some View {
        background {
            GlassBackground()
        }
    }

    func accentGradientForeground() -> some View {
        modifier(AccentGradientText())
    }
}

// MARK: - Components

struct GlassSectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .accentGradientForeground()

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.65))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct GlassIconBadge: View {
    let systemName: String
    var size: CGFloat = 72

    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: size + 24, height: size + 24)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
                .shadow(color: Color.cyan.opacity(0.2), radius: 16, x: 0, y: 8)

            Image(systemName: systemName)
                .font(.system(size: size * 0.45, weight: .light))
                .foregroundStyle(AppTheme.accent)
        }
    }
}

struct GlassWeightDisplay: View {
    let value: String
    let unit: String
    var large: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: large ? 56 : 40, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: Color.cyan.opacity(0.5), radius: 12, x: 0, y: 0)

            Text(unit)
                .font(.system(size: large ? 18 : 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
                .textCase(.uppercase)
                .tracking(1.2)
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 24)
        .glassCard(cornerRadius: 24, tint: .cyan)
    }
}
