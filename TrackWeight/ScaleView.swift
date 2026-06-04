//
//  ScaleView.swift
//  TrackWeight
//

import SwiftUI

struct ScaleView: View {
    @StateObject private var viewModel = ScaleViewModel()
    @State private var scaleCompression: CGFloat = 0
    @State private var displayShake = false
    @State private var keyMonitor: Any?

    var body: some View {
        GeometryReader { geometry in
            let scaleFactor = min(geometry.size.width / 760, geometry.size.height / 560)

            GlassScreenFrame {
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        Text("Track Weight")
                            .font(.system(size: min(max(28, geometry.size.width * 0.04), 36), weight: .bold, design: .rounded))
                            .accentGradientForeground()
                            .multilineTextAlignment(.center)

                        Text("Place your finger on the trackpad to begin")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity)
                            .opacity(viewModel.hasTouch ? 0 : 1)
                            .animation(.easeInOut(duration: 0.5), value: viewModel.hasTouch)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)

                    Spacer(minLength: 12)

                    CartoonScaleView(
                        weight: viewModel.currentWeight,
                        hasTouch: viewModel.hasTouch,
                        compression: $scaleCompression,
                        displayShake: $displayShake,
                        scaleFactor: scaleFactor
                    )

                    Spacer(minLength: 12)

                    GlassFooterBar {
                        VStack(spacing: 10) {
                            if viewModel.hasTouch {
                                Text("Press spacebar or click to zero")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.5))
                            }

                            Button(action: { viewModel.zeroScale() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Zero Scale")
                                }
                            }
                            .buttonStyle(GlassPrimaryButtonStyle())
                            .opacity(viewModel.hasTouch ? 1 : 0)
                            .scaleEffect(viewModel.hasTouch ? 1 : 0.85)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.hasTouch)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .focusable()
        .modifier(FocusEffectModifier())
        .onChange(of: viewModel.currentWeight) { newWeight in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                scaleCompression = CGFloat(min(newWeight / 100.0, 0.2))
            }
        }
        .onAppear {
            viewModel.startListening()
            setupKeyMonitoring()
        }
        .onDisappear {
            viewModel.stopListening()
            removeKeyMonitoring()
        }
    }

    private func setupKeyMonitoring() {
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 49 && viewModel.hasTouch {
                viewModel.zeroScale()
            }
            return event
        }
    }

    private func removeKeyMonitoring() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
    }
}

struct CartoonScaleView: View {
    let weight: Float
    let hasTouch: Bool
    @Binding var compression: CGFloat
    @Binding var displayShake: Bool
    let scaleFactor: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
                .frame(width: 200 * scaleFactor, height: 14 * scaleFactor)
                .offset(y: compression * 15)
                .shadow(color: Color.cyan.opacity(0.2), radius: 8, x: 0, y: 4)

            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.18),
                                        Color.cyan.opacity(0.08)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.15)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .frame(width: 260 * scaleFactor, height: 160 * scaleFactor)
                    .shadow(color: Color.black.opacity(0.35), radius: 24, x: 0, y: 14)

                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.05, green: 0.12, blue: 0.22).opacity(0.9),
                                Color(red: 0.08, green: 0.28, blue: 0.35).opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.cyan.opacity(0.45), lineWidth: 1)
                    )
                    .frame(width: 188 * scaleFactor, height: 64 * scaleFactor)
                    .offset(y: -12)
                    .shadow(color: Color.cyan.opacity(hasTouch ? 0.5 : 0.15), radius: hasTouch ? 12 : 4)

                VStack(spacing: 2) {
                    Text(String(format: "%.1f", weight))
                        .font(.system(size: 34 * scaleFactor, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: Color.cyan.opacity(0.8), radius: hasTouch ? 8 : 0)

                    Text("grams")
                        .font(.system(size: 11 * scaleFactor, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.55))
                        .tracking(0.8)
                }
                .offset(y: -12)

                if hasTouch {
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 8 * scaleFactor, height: 8 * scaleFactor)
                        .shadow(color: .cyan, radius: 6)
                        .offset(x: 95 * scaleFactor, y: -52 * scaleFactor)
                }

                VStack(spacing: 8 * scaleFactor) {
                    HStack(spacing: 15 * scaleFactor) {
                        Circle()
                            .fill(.white.opacity(0.85))
                            .frame(width: 8 * scaleFactor, height: 8 * scaleFactor)
                        Circle()
                            .fill(.white.opacity(0.85))
                            .frame(width: 8 * scaleFactor, height: 8 * scaleFactor)
                    }

                    Group {
                        if hasTouch && weight > 5 {
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addQuadCurve(to: CGPoint(x: 20, y: 0), control: CGPoint(x: 0, y: 15))
                            }
                            .stroke(Color.white.opacity(0.8), lineWidth: 2 * scaleFactor)
                            .frame(width: 20 * scaleFactor, height: 10 * scaleFactor)
                        } else {
                            Capsule()
                                .fill(.white.opacity(0.5))
                                .frame(width: 14 * scaleFactor, height: 2.5 * scaleFactor)
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: weight > 5)
                }
                .offset(y: 58 * scaleFactor)
            }

            HStack(spacing: 140 * scaleFactor) {
                ForEach(0..<2, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.white.opacity(0.25), lineWidth: 0.5)
                        )
                        .frame(width: 14 * scaleFactor, height: 28 * scaleFactor)
                        .offset(y: compression * 3)
                }
            }
            .offset(y: -6)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: compression)
    }
}

struct FocusEffectModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 14.0, *) {
            content.focusEffectDisabled()
        } else {
            content
        }
    }
}

#Preview {
    ZStack {
        GlassBackground()
        ScaleView()
    }
    .frame(width: 700, height: 500)
}
