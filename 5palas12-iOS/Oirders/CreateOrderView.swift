//
//  CreateOrderView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import SwiftUI

struct CreateOrderView: View {
    @EnvironmentObject var ordersVM: OrdersViewModel
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @StateObject private var productVM = ProductViewModel(restaurant: RestaurantModel(id: UUID(), name: "", latitude: 0.0, longitude: 0.0, photo: "", categories: [], description: "", rating: 0.0, address: ""))
    
    // Dejar un producto Anything Available para manejar la conexion eventual
    private let placeholderProduct = ProductModel(name: "Anything available", price: 0.0, categories: [], photo: "")
    
    @State private var userEmail: String = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    @State private var selectedRestaurant: RestaurantModel?
    @State private var selectedProduct: ProductModel?
    @State private var price: Double = 0.0
    @State private var isActive: Bool = true
    @State private var pickUpTime: String = "5PM"
    @State private var showSuccessMessage: Bool = false
    @State private var showErrorMessage: Bool = false
    
    let pickUpTimeOptions = ["5PM", "6PM", "7PM"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                LogoView()
                Text("Create New Order")
                    .font(.title)
                    .padding(.bottom, 20)
                
                Form {
                    Section(header: Text("Order Details")) {
                        
                        Picker("Select Restaurant", selection: $selectedRestaurant) {
                            Text("Choose a restaurant").tag(RestaurantModel?.none)
                            ForEach(restaurantsVM.restaurants) { restaurant in
                                Text(restaurant.name).tag(RestaurantModel?.some(restaurant))
                            }
                        }
                        .onChange(of: selectedRestaurant) { newRestaurant in
                            if let newRestaurant = newRestaurant {
                                productVM.fetchProductsbyRestaurant(restaurant: newRestaurant)
                            }
                        }
                        
                        Picker("Select Product", selection: $selectedProduct) {
                            if productVM.products.isEmpty {
                                Text(placeholderProduct.name).tag(ProductModel?.some(placeholderProduct))
                            } else {
                                Text("Choose a product").tag(ProductModel?.none)
                                ForEach(productVM.products) { product in
                                    Text(product.name).tag(ProductModel?.some(product))
                                }
                            }
                        }
                        .onChange(of: selectedProduct) { newProduct in
                            if let newProduct = newProduct {
                                price = newProduct.price
                            }
                        }
                        
                        Toggle("Order Active", isOn: $isActive)
                        
                        Picker("Pick Up Time", selection: $pickUpTime) {
                            ForEach(pickUpTimeOptions, id: \.self) { time in
                                Text(time).tag(time)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    createOrder()
                }) {
                    Text("Submit Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#228B22"))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                if showSuccessMessage {
                    Text("Order created successfully!")
                        .foregroundColor(.green)
                        .padding(.top)
                }
                
                if showErrorMessage {
                    Text("Failed to create order. Please try again.")
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                // boton
                NavigationLink(destination: OrdersListView()) {
                    Text("Go to Order List")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#228B22"))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .background(Color("Timberwolf"))
            .onAppear {
                restaurantsVM.loadRestaurants()
            }
        }
    }
    
    private func createOrder() {
        guard let selectedProduct = selectedProduct, let selectedRestaurant = selectedRestaurant else {
            showErrorMessage = true
            return
        }
        
        let productNames = [selectedProduct.name]
        
        ordersVM.createOrder(
            userEmail: userEmail,
            products: productNames,
            price: selectedProduct.price,
            isActive: isActive,
            pickUpTime: pickUpTime,
            restaurantName: selectedRestaurant.name
        )
        
        showSuccessMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSuccessMessage = false
        }
    }
}
