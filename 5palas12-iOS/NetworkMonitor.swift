//
//  NetworkMonitor.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 2/11/24.
//

import Foundation
import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    let monitor : NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    @Published var isConnected: Bool = true

    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
