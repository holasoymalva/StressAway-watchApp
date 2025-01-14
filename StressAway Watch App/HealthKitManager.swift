//
//  HealthKitManager.swift
//  StressAway
//
//  Created by malva on 13/01/25.
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    private var healthStore = HKHealthStore()
    private let heartRateQuantity = HKUnit(from: "count/min")
    
    @Published var currentHeartRate: Double = 0
    @Published var currentHRV: Double = 0
    @Published var stressLevel: StressLevel = .normal
    @Published var isAuthorized = false
    
    enum StressLevel {
        case low
        case normal
        case elevated
        case high
    }
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.startHeartRateMonitoring()
                    self.startHRVMonitoring()
                }
            }
        }
    }
    
    func startHeartRateMonitoring() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKAnchoredObjectQuery(type: heartRateType,
                                        predicate: nil,
                                        anchor: nil,
                                        limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, anchor, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            self?.processSamples(samples)
        }
        
        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            self?.processSamples(samples)
        }
        
        healthStore.execute(query)
    }
    
    private func processSamples(_ samples: [HKQuantitySample]) {
        guard let latestSample = samples.last else { return }
        
        DispatchQueue.main.async {
            self.currentHeartRate = latestSample.quantity.doubleValue(for: self.heartRateQuantity)
            self.calculateStressLevel()
        }
    }
    
    func startHRVMonitoring() {
        guard let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else { return }
        
        let query = HKAnchoredObjectQuery(type: hrvType,
                                        predicate: nil,
                                        anchor: nil,
                                        limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, anchor, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            self?.processHRVSamples(samples)
        }
        
        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            guard let samples = samples as? [HKQuantitySample] else { return }
            self?.processHRVSamples(samples)
        }
        
        healthStore.execute(query)
    }
    
    private func processHRVSamples(_ samples: [HKQuantitySample]) {
        guard let latestSample = samples.last else { return }
        
        DispatchQueue.main.async {
            self.currentHRV = latestSample.quantity.doubleValue(for: HKUnit.second())
             self.calculateStressLevel()
        }
    }
    
    private func calculateStressLevel() {
        // Simple stress level calculation based on heart rate and HRV
        // You may want to adjust these thresholds based on user's baseline
        if currentHeartRate > 100 && currentHRV < 30 {
            stressLevel = .high
        } else if currentHeartRate > 85 && currentHRV < 40 {
            stressLevel = .elevated
        } else if currentHeartRate > 70 && currentHRV < 50 {
            stressLevel = .normal
        } else {
            stressLevel = .low
        }
    }
}
