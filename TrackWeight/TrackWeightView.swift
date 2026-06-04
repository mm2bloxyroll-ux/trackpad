//
//  TrackWeightView.swift
//  TrackWeight
//

import SwiftUI

struct TrackWeightView: View {
    @StateObject private var viewModel = WeighingViewModel()

    var body: some View {
        GlassScreenFrame {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    switch viewModel.state {
                    case .welcome:
                        WelcomeView {
                            viewModel.startWeighing()
                        }

                    case .waitingForFinger:
                        FingerTimerView(
                            progress: viewModel.fingerTimer,
                            hasDetectedFinger: viewModel.fingerTimer > 0
                        )

                    case .waitingForItem:
                        InstructionView(
                            title: "Place your item",
                            subtitle: "While maintaining contact with the trackpad, gently place your item. Use as little pressure as possible with your reference finger.",
                            disclaimer: "Keep your finger still and apply minimal pressure",
                            icon: "cube.box"
                        )

                    case .weighing:
                        WeighingView(
                            currentPressure: viewModel.currentPressure,
                            isStabilizing: viewModel.isStabilizing,
                            stabilityProgress: viewModel.stabilityProgress
                        )

                    case .result(let weight):
                        ResultView(weight: weight) {
                            viewModel.restart()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.5), value: viewModel.state)
    }
}

struct WelcomeView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            GlassIconBadge(systemName: "scalemass", size: 72)

            GlassSectionHeader(
                title: "Guided Weigh",
                subtitle: "Step-by-step precision on your trackpad"
            )

            Text("Turn your trackpad into a precision scale. Place objects and get their weight in grams.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 400)

            Button(action: onStart) {
                Text("Start")
            }
            .buttonStyle(GlassPrimaryButtonStyle())
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 28)
    }
}

struct FingerTimerView: View {
    let progress: Float
    let hasDetectedFinger: Bool

    var body: some View {
        VStack(spacing: 28) {
            GlassIconBadge(systemName: "hand.point.up.left", size: 56)

            GlassSectionHeader(
                title: "Hold your finger steady",
                subtitle: "Keep contact for 3 seconds to set baseline"
            )

            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.15), lineWidth: 6)
                    .frame(width: 120, height: 120)

                Circle()
                    .fill(Color.cyan.opacity(0.08))
                    .frame(width: 120, height: 120)

                if hasDetectedFinger {
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            AppTheme.accent,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1), value: progress)

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.cyan.opacity(0.35), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 55
                            )
                        )
                        .frame(width: CGFloat(progress) * 90 + 24, height: CGFloat(progress) * 90 + 24)
                        .animation(.easeInOut(duration: 0.2), value: progress)

                    Text("\(Int((1 - progress) * 3) + 1)")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .scaleEffect(hasDetectedFinger ? 1 : 0.88)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: hasDetectedFinger)
        }
        .padding(36)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 28)
    }
}

struct InstructionView: View {
    let title: String
    let subtitle: String
    let disclaimer: String?
    let icon: String

    init(title: String, subtitle: String, disclaimer: String? = nil, icon: String) {
        self.title = title
        self.subtitle = subtitle
        self.disclaimer = disclaimer
        self.icon = icon
    }

    var body: some View {
        VStack(spacing: 22) {
            GlassIconBadge(systemName: icon, size: 52)

            Text(title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .accentGradientForeground()

            VStack(spacing: 12) {
                Text(subtitle)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.72))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)

                if let disclaimer {
                    Text(disclaimer)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.orange.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.12))
                                .overlay(Capsule().stroke(Color.orange.opacity(0.3), lineWidth: 1))
                        )
                }
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 28)
    }
}

struct WeighingView: View {
    let currentPressure: Float
    let isStabilizing: Bool
    let stabilityProgress: Float

    var body: some View {
        VStack(spacing: 24) {
            Text("Weighing…")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))

            GlassWeightDisplay(
                value: String(format: "%.1f", currentPressure),
                unit: "grams",
                large: true
            )
            .animation(.easeInOut(duration: 0.2), value: currentPressure)

            VStack(spacing: 14) {
                Text("Release pressure while maintaining contact")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.orange.opacity(0.95))
                    .multilineTextAlignment(.center)

                Text("Keep your finger on the trackpad but apply as little pressure as possible")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 340)

                if isStabilizing {
                    VStack(spacing: 10) {
                        Text("Stabilizing…")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color.orange.opacity(0.9))

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 220, height: 8)

                            Capsule()
                                .fill(AppTheme.warmAccent)
                                .frame(width: 220 * CGFloat(stabilityProgress), height: 8)
                                .animation(.linear(duration: 0.1), value: stabilityProgress)
                        }

                        Text("\(Int((1 - stabilityProgress) * 2) + 1)s remaining")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundStyle(.white.opacity(0.45))
                    }
                    .padding(16)
                    .glassCard(cornerRadius: 14, tint: .orange)
                }
            }
        }
    }
}

struct ResultView: View {
    let weight: Float
    let onRestart: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .green.opacity(0.4), radius: 12)

            Text("Your object weighs")
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.65))

            GlassWeightDisplay(
                value: String(format: "%.1f", weight),
                unit: "grams",
                large: true
            )

            Button(action: onRestart) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Weigh again")
                }
            }
            .buttonStyle(GlassPrimaryButtonStyle())
        }
        .padding(36)
        .frame(maxWidth: .infinity)
        .glassCard(cornerRadius: 28, tint: .green, borderTint: .green)
    }
}

#Preview {
    ZStack {
        GlassBackground()
        TrackWeightView()
    }
    .frame(width: 700, height: 500)
}
