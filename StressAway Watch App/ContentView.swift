//
//  ContentView.swift
//  StressAway Watch App
//
//  Created by malva on 13/01/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var showingBreakAlert = false
    @State private var lastAlertTime: Date? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            StressGaugeView(stressLevel: healthKitManager.stressLevel)
                .frame(width: 120, height: 120)
            
            Text("Heart Rate: \(Int(healthKitManager.currentHeartRate)) BPM")
                .font(.system(.headline, design: .rounded))
            
            Text("HRV: \(Int(healthKitManager.currentHRV)) ms")
                .font(.system(.headline, design: .rounded))
            
            StressLevelView(stressLevel: healthKitManager.stressLevel)
        }
        .padding()
        .onAppear {
            startStressMonitoring()
        }
        .alert(isPresented: $showingBreakAlert) {
            Alert(
                title: Text("Time for a Break"),
                message: Text("Your stress levels are elevated. Take a minute to breathe."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func startStressMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            checkStressLevels()
        }
    }
    
    private func checkStressLevels() {
        let minimumTimeBetweenAlerts: TimeInterval = 1800 // 30 minutes
        
        if healthKitManager.stressLevel == .high {
            if let lastAlert = lastAlertTime {
                let timeSinceLastAlert = Date().timeIntervalSince(lastAlert)
                if timeSinceLastAlert >= minimumTimeBetweenAlerts {
                    showAlert()
                }
            } else {
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        showingBreakAlert = true
        lastAlertTime = Date()
    }
}
