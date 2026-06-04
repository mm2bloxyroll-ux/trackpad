//
//  HomeView.swift
//  TrackWeight
//

import SwiftUI

struct HomeView: View {
    let onBegin: () -> Void

    var body: some View {
        ZStack {
            GlassBackground()

            GlassScreenFrame {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.bottom, AppLayout.sectionSpacing)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: AppLayout.sectionSpacing) {
                            descriptionSection
                            limitationsSection
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    GlassFooterBar {
                        Button(action: onBegin) {
                            HStack(spacing: 10) {
                                Text("Begin")
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                        }
                        .buttonStyle(GlassPrimaryButtonStyle())
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            GlassIconBadge(systemName: "scalemass", size: 72)

            Text("TrackWeight")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .accentGradientForeground()
                .multilineTextAlignment(.center)

            Text("Precision scale for your MacBook trackpad")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var descriptionSection: some View {
        Text("Transform your MacBook trackpad into a precision scale with gram-level pressure readings.")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundStyle(.white.opacity(0.85))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .padding(.vertical, 20)
            .glassCard(cornerRadius: 16, tint: .cyan, borderTint: .cyan)
    }

    private var limitationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Important Limitations")
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.orange, Color(red: 1, green: 0.75, blue: 0.4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 12) {
                LimitationRow(
                    icon: "hand.point.up.left",
                    text: "Requires finger contact for capacitive detection"
                )
                LimitationRow(
                    icon: "chart.line.downtrend.xyaxis",
                    text: "May experience pressure drift when placing objects"
                )
                LimitationRow(
                    icon: "cube.fill",
                    text: "Metal or magnetic objects may not work reliably"
                )
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard(cornerRadius: 18, tint: .orange, borderWidth: 2, borderTint: .orange)
    }
}

struct LimitationRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.orange.opacity(0.95))
                .frame(width: 22, alignment: .center)
                .padding(.top, 2)

            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.78))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    HomeView(onBegin: {})
        .frame(width: 760, height: 600)
        .preferredColorScheme(.dark)
}
