//
//  TimeManager.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import SwiftUI
import Combine

class TimeManager: ObservableObject {
    @Published var currentTime: Date = Date()
    
    init() {
        startUpdatingTime()
    }
    
    private func startUpdatingTime() {
        DispatchQueue.global(qos: .background).async {
            while true {
                let now = Date()
                
                DispatchQueue.main.async {
                    self.currentTime = now
                }
                
                Thread.sleep(forTimeInterval: 1) // Every second
            }
        }
    }
}

