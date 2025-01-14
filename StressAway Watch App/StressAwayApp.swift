//
//  StressAwayApp.swift
//  StressAway Watch App
//
//  Created by malva on 13/01/25.
//

import SwiftUI
import HealthKit
import WatchKit

@main
struct StressAwayApp: App {
    @StateObject private var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(healthKitManager)
            }
        }
    }
}
