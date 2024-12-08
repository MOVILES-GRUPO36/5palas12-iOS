//
//  FirebaseLogger.swift
//  5palas12-iOS
//
//  Created by santiago on 8/12/24.
//

import Foundation
import FirebaseAnalytics

final class FirebaseLogger {
    static let shared = FirebaseLogger()
    
    private init() {}
    
    private let loggingQueue = DispatchQueue(label: "com.logger.queue", qos: .background)
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        loggingQueue.async { [weak self] in
            self?.performLogging(viewName: viewName, timeSpent: timeSpent)
        }
    }
    
    private func performLogging(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
    }
}
