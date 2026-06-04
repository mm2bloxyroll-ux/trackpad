//
//  SettingsView.swift
//  TrackWeight
//

import OpenMultitouchSupport
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = ContentViewModel()
    @State private var showDebugView = false

    var body: some View {
        GlassScreenFrame {
            VStack(spacing: 0) {
                GlassSectionHeader(title: "Settings", subtitle: "Trackpad & diagnostics")
                    .padding(.bottom, AppLayout.sectionSpacing)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        SettingsCard {
                            VStack(spacing: 20) {
                                HStack {
                                    Label {
                                        Text("Trackpad")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.white.opacity(0.95))
                                    } icon: {
                                        Image(systemName: "rectangle.and.hand.point.up.left")
                                            .foregroundStyle(AppTheme.accent)
                                    }

                                    Spacer()

                                    if !viewModel.availableDevices.isEmpty {
                                        Text("\(viewModel.availableDevices.count) device\(viewModel.availableDevices.count == 1 ? "" : "s")")
                                            .font(.caption.weight(.medium))
                                            .foregroundStyle(.white.opacity(0.5))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Capsule().fill(.white.opacity(0.08)))
                                    }
                                }

                                if !viewModel.availableDevices.isEmpty {
                                    HStack {
                                        Picker("", selection: Binding(
                                            get: { viewModel.selectedDevice },
                                            set: { device in
                                                if let device = device {
                                                    viewModel.selectDevice(device)
                                                }
                                            }
                                        )) {
                                            ForEach(viewModel.availableDevices, id: \.self) { device in
                                                Text(device.deviceName)
                                                    .tag(device as OMSDeviceInfo?)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        .tint(.white)

                                        Spacer()
                                    }
                                } else {
                                    HStack {
                                        Text("No devices available")
                                            .foregroundStyle(.white.opacity(0.5))
                                        Spacer()
                                    }
                                }
                            }
                        }

                        SettingsCard {
                            Button(action: { showDebugView = true }) {
                                HStack(spacing: 16) {
                                    GlassIconBadge(systemName: "terminal", size: 44)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Debug Console")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.white.opacity(0.95))

                                        Text("Raw touch data & diagnostics")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.55))
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.white.opacity(0.4))
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(CardButtonStyle())
                        }
                    }
                    .frame(maxWidth: 480)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showDebugView) {
            DebugView()
                .frame(
                    minWidth: AppLayout.windowMinWidth,
                    minHeight: AppLayout.windowMinHeight
                )
                .preferredColorScheme(.dark)
        }
        .onAppear {
            viewModel.loadDevices()
        }
    }
}

struct SettingsCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassCard(cornerRadius: 18, borderWidth: 1.5)
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        GlassBackground()
        SettingsView()
    }
    .frame(width: 760, height: 600)
}
