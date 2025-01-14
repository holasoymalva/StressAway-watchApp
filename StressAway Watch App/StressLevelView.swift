//
//  StressLevelView.swift
//  StressAway
//
//  Created by malva on 13/01/25.
//
import SwiftUI

struct StressLevelView: View {
    let stressLevel: HealthKitManager.StressLevel
    
    var body: some View {
        VStack {
            Text("Stress Level")
                .font(.headline)
            
            Text(stressLevelText)
                .font(.title2)
                .foregroundColor(stressColor)
                .fontWeight(.bold)
        }
    }
    
    private var stressLevelText: String {
        switch stressLevel {
        case .low: return "Low"
        case .normal: return "Normal"
        case .elevated: return "Elevated"
        case .high: return "High"
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
