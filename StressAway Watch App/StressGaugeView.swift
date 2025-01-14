//
//  StressGaugeView.swift
//  StressAway
//
//  Created by malva on 13/01/25.
//
import SwiftUI

struct StressGaugeView: View {
    let stressLevel: HealthKitManager.StressLevel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 15)
            
            Circle()
                .trim(from: 0, to: stressIndicatorValue)
                .stroke(stressColor, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: stressIndicatorValue)
        }
    }
    
    private var stressIndicatorValue: Double {
        switch stressLevel {
        case .low: return 0.25
        case .normal: return 0.5
        case .elevated: return 0.75
        case .high: return 1.0
        }
    }
    
    private var stressColor: Color {
        switch stressLevel {
        case .low: return .green
        case .normal: return .blue
        case .elevated: return .orange
        case .high: return .red
        }
    }
}
