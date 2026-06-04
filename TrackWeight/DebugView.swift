//
//  DebugView.swift
//  TrackWeight
//

import OpenMultitouchSupport
import SwiftUI

struct DebugView: View {
    @StateObject var viewModel = ContentViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GlassBackground()

            VStack(spacing: 20) {
                HStack {
                    Text("Debug Console")
                        .font(.title2.weight(.bold))
                        .accentGradientForeground()

                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .help("Close Debug Console")
                }

                if !viewModel.availableDevices.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Trackpad Device")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.85))

                        Picker("Select Device", selection: Binding(
                            get: { viewModel.selectedDevice },
                            set: { device in
                                if let device = device {
                                    viewModel.selectDevice(device)
                                }
                            }
                        )) {
                            ForEach(viewModel.availableDevices, id: \.self) { device in
                                Text("\(device.deviceName) (ID: \(device.deviceID))")
                                    .tag(device as OMSDeviceInfo?)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                    }
                    .padding(20)
                    .glassCard(cornerRadius: 16)
                }

                if viewModel.isListening {
                    Button { viewModel.stop() } label: { Text("Stop") }
                        .buttonStyle(GlassPrimaryButtonStyle())
                } else {
                    Button { viewModel.start() } label: { Text("Start") }
                        .buttonStyle(GlassPrimaryButtonStyle())
                }

                Canvas { context, size in
                    viewModel.touchData.forEach { touch in
                        let path = makeEllipse(touch: touch, size: size)
                        context.fill(path, with: .color(.cyan.opacity(Double(touch.total))))
                    }
                }
                .frame(width: 600, height: 400)
                .glassCard(cornerRadius: 16)
            }
            .padding(28)
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
    }

    private func makeEllipse(touch: OMSTouchData, size: CGSize) -> Path {
        let x = Double(touch.position.x) * size.width
        let y = Double(1.0 - touch.position.y) * size.height
        let u = size.width / 100.0
        let w = Double(touch.axis.major) * u
        let h = Double(touch.axis.minor) * u
        return Path(ellipseIn: CGRect(x: -0.5 * w, y: -0.5 * h, width: w, height: h))
            .rotation(.radians(Double(-touch.angle)), anchor: .topLeading)
            .offset(x: x, y: y)
            .path(in: CGRect(origin: .zero, size: size))
    }
}

#Preview {
    DebugView()
        .frame(width: 700, height: 500)
}
