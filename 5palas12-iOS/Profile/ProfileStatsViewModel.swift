//
//  ProfileStatsViewModel.swift
//  5palas12-iOS
//
//  Created by santiago on 3/12/24.
//

import Foundation
import Combine

class ProfileStatsViewModel: ObservableObject {
    @Published var stats: (moneySaved: Double, co2Saved: Double, weightSaved: Double) = (0.0, 0.0, 0.0)
    @Published var treesPlanted: String?
    
    private var orderDAO = OrderDAO()
    private var productDAO = ProductDAO()
    
    var userEmail: String

    init(userEmail: String) {
        self.userEmail = userEmail
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrderChange), name: .ordersDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleOrderChange(_ notification: Notification) {
        print("Notification .ordersDidChange received")
        
        if let userEmail = notification.userInfo?["userEmail"] as? String {
            print("User email extracted from notification: \(userEmail)")
            ProfileStatsCache.shared.clearCache()
            fetchStats(for: userEmail)
        }
    }

    func fetchStats(for userEmail: String) {
        print("fetchStats called for userEmail: \(userEmail)")

        if let cachedStats = ProfileStatsCache.shared.stats {
            stats = cachedStats
            treesPlanted = ProfileStatsCache.shared.treesPlanted
            print("Using cached stats: \(cachedStats)")
            return
        }

        orderDAO.getAllOrders(byUserEmail: userEmail) { result in
            switch result {
            case .success(let orders):
                print("Orders fetched successfully.")
                self.calculateStats(from: orders)
            case .failure(let error):
                print("Failed to load orders: \(error.localizedDescription)")
            }
        }
    }

    func calculateStats(from orders: [OrderModel]) {
        var totalMoneySaved: Double = 0.0
        var totalCo2Saved: Double = 0.0
        var totalWeightSaved: Double = 0.0
        let dispatchGroup = DispatchGroup()

        for order in orders {
            for productName in order.products {
                dispatchGroup.enter()
                fetchProductByName(productName) { product in
                    if let product = product {
                        totalMoneySaved += product.price
                        totalCo2Saved += product.co2Emissions
                        totalWeightSaved += product.weight
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.stats = (totalMoneySaved, totalCo2Saved, totalWeightSaved)
            self.treesPlanted = totalCo2Saved > 0 ? "This is equivalent to \(Int(totalCo2Saved / 21)) trees planted!" : nil
            
            ProfileStatsCache.shared.stats = self.stats
            ProfileStatsCache.shared.treesPlanted = self.treesPlanted

            print("Stats updated: \(self.stats)")
            print("Trees planted: \(self.treesPlanted ?? "N/A")")
        }
    }

    private func fetchProductByName(_ name: String, completion: @escaping (ProductModel?) -> Void) {
        productDAO.getProductByName(name) { result in
            switch result {
            case .success(let product):
                completion(product)
            case .failure(let error):
                print("Failed to fetch product: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
