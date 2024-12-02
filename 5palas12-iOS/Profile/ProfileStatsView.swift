//  ProfileStatsView.swift
//  5palas12-iOS
//
//  Created by santiago on 1/12/24.
//

import SwiftUI

struct ProfileStatsView: View {
    @State private var moneySaved: Double = 0.0
    @State private var co2Saved: Double = 0.0
    @State private var weightSaved: Double = 0.0 // New variable for weight saved
    private let orderDAO = OrderDAO()
    @State var userEmail: String

    var body: some View {
            VStack {
                // Money Invested Card
                VStack {
                    HStack {
                        Image(systemName: "banknote") // Bill icon
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(Color.fernGreen) // Green color for eco-friendliness
                        
                        Text("Money invested this month saving the planet!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .padding()
                    
                    // Display the amount of money saved
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
                
                // CO2 Saved Card
                VStack {
                    HStack {
                        Image(systemName: "leaf.fill") // Leaf icon
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.fernGreen) // Green color for eco-friendliness
                        
                        Text("CO2 saved this month!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.leading, 10)
                    }
                    .padding()
                    
                    // Display the amount of CO2 saved
                    Text("\(co2Saved, specifier: "%.2f") kg")
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
                
                // Weight Saved Card
                VStack {
                    HStack {
                        Image(systemName: "fork.knife") // Drop icon to symbolize weight or size
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.fernGreen) // Blue color for weight
                        
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
    
    // Function to process the orders and calculate the statistics
    private func calculateStats(from orders: [OrderModel]) {
        var totalMoneySaved: Double = 0.0
        var totalCo2Saved: Double = 0.0
        var totalWeightSaved: Double = 0.0 // New variable for total weight
        let dispatchGroup = DispatchGroup() // Create DispatchGroup to wait for all async tasks
        
        // Iterate through the orders and calculate the total money, CO2, and weight saved
        for order in orders {
            print("Order ID: \(order.id)")
            for productName in order.products {
                print("Product Name: \(productName)") // Print product name
                
                dispatchGroup.enter() // Enter the dispatch group before starting the async task
                
                // Fetch the product details using the product name from Firestore
                fetchProductByName(productName) { product in
                    if let product = product {
                        totalMoneySaved += product.price
                        totalCo2Saved += product.co2Emissions
                        totalWeightSaved += product.weight // Add the weight of the product
                    }
                    
                    dispatchGroup.leave() // Leave the dispatch group when the async task is complete
                }
            }
        }
        
        // Notify when all async tasks are completed
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.moneySaved = totalMoneySaved
                self.co2Saved = totalCo2Saved
                self.weightSaved = totalWeightSaved // Update the weight value
            }
        }
    }

    // Fetch product information from Firestore by product name
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

    // Print orders and their associated products
    private func printOrdersAndProducts(_ orders: [OrderModel]) {
        for order in orders {
            print("Order ID: \(order.id)") // Print each order ID
            print("Products in this order:")
            for productName in order.products {
                print("  - Product Name: \(productName)") // Print product name
            }
        }
    }
}
