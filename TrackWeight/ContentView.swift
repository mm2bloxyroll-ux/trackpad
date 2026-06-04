//
//  ContentView.swift
//  TrackWeight
//

import SwiftUI

struct ContentView: View {
    @State private var showHomePage = true
    @State private var selectedTab = 1

    var body: some View {
        Group {
            if showHomePage {
                HomeView {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        showHomePage = false
                    }
                }
            } else {
                mainTabs
            }
        }
        .frame(
            minWidth: AppLayout.windowMinWidth,
            minHeight: AppLayout.windowMinHeight
        )
        .preferredColorScheme(.dark)
    }

    private var mainTabs: some View {
        ZStack {
            GlassBackground()

            TabView(selection: $selectedTab) {
                TrackWeightView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "arrow.3.trianglepath")
                        Text("Guided")
                    }
                    .tag(0)

                ScaleView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "scalemass")
                        Text("Scale")
                    }
                    .tag(1)

                SettingsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .tag(2)
            }
        }
    }
}

#Preview {
    ContentView()
}
