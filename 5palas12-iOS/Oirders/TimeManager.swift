//
//  TimeManager.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import SwiftUI
import SwiftUI
import Combine

class TimeManager: ObservableObject {
    @Published var currentTime: Date = Date()
    
    init() {
        startUpdatingTime()
    }
    
    private func startUpdatingTime() {
        // Using Grand Central Dispatch to update time every second
        DispatchQueue.global(qos: .background).async {
            while true {
                let now = Date() // Get the current date and time
                DispatchQueue.main.async {
                    self.currentTime = now
                }
                Thread.sleep(forTimeInterval: 1) // Sleep for 1 second
            }
        }
    }
}
