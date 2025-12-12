//
//  ScaleViewModel.swift
//  TrackWeight
//

import OpenMultitouchSupport
import SwiftUI
import Combine

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case grams = "g"
    case ounces = "oz"
    case pounds = "lb"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .grams: return "grams"
        case .ounces: return "ounces"
        case .pounds: return "pounds"
        }
    }
    
    func convert(_ grams: Float) -> Float {
        switch self {
        case .grams: return grams
        case .ounces: return grams / 28.3495
        case .pounds: return grams / 453.592
        }
    }
}

@MainActor
final class ScaleViewModel: ObservableObject {
    @Published var currentWeight: Float = 0.0
    @Published var zeroOffset: Float = 0.0
    @Published var isListening = false
    @Published var hasTouch = false
    @Published var selectedUnit: MeasurementUnit = .grams
    
    private let manager = OMSManager.shared
    private var task: Task<Void, Never>?
    private var rawWeight: Float = 0.0
    
    func startListening() {
        if manager.startListening() {
            isListening = true
        }
        
        task = Task { [weak self, manager] in
            for await touchData in manager.touchDataStream {
                await MainActor.run {
                    self?.processTouchData(touchData)
                }
            }
        }
    }
    
    func stopListening() {
        task?.cancel()
        if manager.stopListening() {
            isListening = false
            hasTouch = false
            currentWeight = 0.0
        }
    }
    
    func zeroScale() {
        if hasTouch {
            zeroOffset = rawWeight
        }
    }
    
    private func processTouchData(_ touchData: [OMSTouchData]) {
        if touchData.isEmpty {
            hasTouch = false
            currentWeight = 0.0
            zeroOffset = 0.0  // Reset zero when finger is lifted
        } else {
            hasTouch = true
            rawWeight = touchData.first?.pressure ?? 0.0
            let weightInGrams = max(0, rawWeight - zeroOffset)
            currentWeight = selectedUnit.convert(weightInGrams)
        }
    }
    
    deinit {
        task?.cancel()
        manager.stopListening()
    }
}