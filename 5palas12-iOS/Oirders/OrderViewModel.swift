//
//  OrderViewModel.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import Foundation
import Combine
import Network

class OrdersViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var errorMessage: String?
    @Published var isOnline = true
    
    private var cancellables = Set<AnyCancellable>()
    private let orderDAO = OrderDAO()
    
    init() {
        monitorNetworkStatus()
    }
    
    func fetchOrders(byUserEmail email: String) {
        orderDAO.getAllOrders(byUserEmail: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newOrders):
                    if self?.orders != newOrders {
                        self?.orders = newOrders
                    }
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch orders: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createOrder(userEmail: String, products: [String], price: Double, isActive: Bool, pickUpTime: String, restaurantName: String) {
        let newOrderNumber = Double.random(in: 1000...9999)
        let newOrder = OrderModel(orderNumber: newOrderNumber, userEmail: userEmail, products: products, price: price, isActive: isActive, pickUpTime: pickUpTime, restaurantName: restaurantName)
        
        if isOnline {
            orderDAO.createOrder(newOrder) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.fetchOrders(byUserEmail: userEmail)
                    case .failure(let error):
                        self?.errorMessage = "Failed to create order: \(error.localizedDescription)"
                    }
                }
            }
        } else {
            orderDAO.saveOrderLocally(newOrder)
            DispatchQueue.main.async {
                self.orders.append(newOrder)
                self.errorMessage = "Order saved locally. It will be synced once back online."
            }
        }
    }
    
    private func monitorNetworkStatus() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = path.status == .satisfied
                if self?.isOnline == true {
                    self?.orderDAO.syncLocalOrdersToFirestore()
                    if let email = UserDefaults.standard.string(forKey: "currentUserEmail") {
                        self?.fetchOrders(byUserEmail: email)
                    }
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
