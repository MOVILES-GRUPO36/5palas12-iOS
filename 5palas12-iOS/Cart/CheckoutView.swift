//
//  CheckoutView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 8/12/24.
//

//
//  CheckoutView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 8/12/24.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var ordersVM: OrdersViewModel
    @EnvironmentObject var userVM: UserViewModel
    @State private var isPlacingOrder = false
    @State private var showConfirmation = false
    @State private var errorMessage: String? = nil
    @State private var selectedPickupTime = "5PM" 

    let pickupTimes = ["5PM", "6PM", "7PM"]

    var body: some View {
        VStack {
            Text("Checkout")
                .font(.largeTitle)
                .padding()

            if cartVM.products.isEmpty {
                VStack {
                    Spacer()
                    Text("No products to checkout")
                        .font(.headline)
                    Spacer()
                }
                .background(Color.timberwolf)
            } else {
                ScrollView {
                    VStack {
                        ForEach(cartVM.products) { product in
                            HStack {
                                AsyncImage(url: URL(string: product.photo)) { image in
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    Image(systemName: "fork.knife")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .foregroundColor(.fernGreen)
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)

                                VStack(alignment: .leading) {
                                    Text(product.name)
                                        .font(.headline)
                                    Text("Price: $\(product.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                }

                                Spacer()

                                Button(action: {
                                    cartVM.removeProduct(product)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .background(Color.timberwolf)

                VStack(spacing: 16) {
                    Text("Total: $\(cartVM.products.reduce(0) { $0 + $1.price }, specifier: "%.2f")")
                        .font(.headline)

                    // Picker para seleccionar la hora de recogida
                    Picker("Pickup Time", selection: $selectedPickupTime) {
                        ForEach(pickupTimes, id: \.self) { time in
                            Text(time).tag(time)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Button(action: placeOrders) {
                        HStack {
                            Image(systemName: "text.badge.plus")
                                .foregroundColor(.white)
                                .padding(.trailing, 5)
                            Text("Confirm and Place Orders")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isPlacingOrder ? Color.gray : Color.fernGreen)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .disabled(isPlacingOrder)
                }
                .padding()
            }
        }
        .background(Color.timberwolf)
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text(errorMessage == nil ? "Success" : "Error"),
                message: Text(errorMessage ?? "Orders placed successfully!"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func placeOrders() {
        guard let userEmail = userVM.userData?.email else { return }

        isPlacingOrder = true
        errorMessage = nil

        for product in cartVM.products {
            ordersVM.createOrder(
                userEmail: userEmail,
                products: [product.name],
                price: product.price,
                isActive: true,
                pickUpTime: selectedPickupTime, // Usar la hora seleccionada
                restaurantName: product.restaurant
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cartVM.products.removeAll()
            isPlacingOrder = false
            showConfirmation = true
        }
    }
}
