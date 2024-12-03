//  ProfileStatsView.swift
//  5palas12-iOS
//
//  Created by santiago on 1/12/24.
//

import SwiftUI

struct ProfileStatsView: View {
    @State private var moneySaved: Double = 0.0
    @State private var co2Saved: Double = 0.0
    @State private var weightSaved: Double = 0.0
    private let orderDAO = OrderDAO()
    @State var userEmail: String

    var body: some View {
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "banknote")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(Color.fernGreen)
                        
                        Text("Money invested this month saving the planet!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .padding()
                    
                    Text("$\(moneySaved, specifier: "%.2f")")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.fernGreen)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)

                VStack {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.fernGreen)
                        
                        Text("CO₂ saved this month!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .padding()
                    
                    Text("\(co2Saved, specifier: "%.2f") kg")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.fernGreen)
                        .padding(.top, 5)
                    
                    if co2Saved > 0 {
                        let treesEquivalent = co2Saved / 21
                        Text("This is equivalent to **\(Int(treesEquivalent)) trees planted**!")
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
                
                VStack {
                    HStack {
                        Image(systemName: "fork.knife")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.fernGreen)
                        
                        Text("Amount of food saved from waste this month!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .padding()
                    
                    // Display the amount of weight saved
                    Text("\(weightSaved, specifier: "%.2f") kg")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.fernGreen)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)
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
    
    private func calculateStats(from orders: [OrderModel]) {
        var totalMoneySaved: Double = 0.0
        var totalCo2Saved: Double = 0.0
        var totalWeightSaved: Double = 0.0
        let dispatchGroup = DispatchGroup()
        
        for order in orders {
            print("Order ID: \(order.id)")
            for productName in order.products {
                print("Product Name: \(productName)")
                
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
            DispatchQueue.main.async {
                self.moneySaved = totalMoneySaved
                self.co2Saved = totalCo2Saved
                self.weightSaved = totalWeightSaved
            }
        }
    }

    private func fetchProductByName(_ name: String, completion: @escaping (ProductModel?) -> Void) {
        let productDAO = ProductDAO()
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
