//  ProfileStatsView.swift
//  5palas12-iOS
//
//  Created by santiago on 1/12/24.
//

import SwiftUI

struct ProfileStatsView: View {
    @State private var stats: (moneySaved: Double, co2Saved: Double, weightSaved: Double) = (0.0, 0.0, 0.0)
    @State private var treesPlanted: String?
    private var orderDAO = OrderDAO()
    private var productDAO = ProductDAO()
    @State var userEmail: String
    
    init(userEmail: String) {
            self._userEmail = State(initialValue: userEmail)
        }
    
    var body: some View {
        VStack {
            LazyVStack {
                StatCardView(
                    iconName: "banknote",
                    title: "Money invested this month saving the planet!",
                    value: String(format: "$%.2f", stats.moneySaved),
                    footer: nil
                )

                StatCardView(
                    iconName: "leaf.fill",
                    title: "CO₂ saved this month!",
                    value: String(format: "%.2f kg", stats.co2Saved),
                    footer: treesPlanted
                )

                StatCardView(
                    iconName: "fork.knife",
                    title: "Amount of food saved from waste this month!",
                    value: String(format: "%.2f kg", stats.weightSaved),
                    footer: nil
                )
            }
            .padding(.top, 20)
            .onAppear {
                print("Querying orders for email: \(userEmail)")
                orderDAO.getAllOrders(byUserEmail: userEmail) { result in
                    switch result {
                    case .success(let orders):
                        print("Orders fetched successfully.")
                        printOrdersAndProducts(orders)
                        calculateStats(from: orders)
                    case .failure(let error):
                        print("Failed to load orders: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func calculateStats(from orders: [OrderModel]) {
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

    private func printOrdersAndProducts(_ orders: [OrderModel]) {
        for order in orders {
            print("Order ID: \(order.id)")
            print("Products in this order:")
            for productName in order.products {
                print("  - Product Name: \(productName)")
            }
        }
    }
}

struct StatCardView: View {
    var iconName: String
    var title: String
    var value: String
    var footer: String?

    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.fernGreen)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
            }
            .padding()
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.fernGreen)
                .padding(.top, 5)
            if let footerText = footer {
                Text(footerText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

