//
//  CartView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 2/12/24.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    var body: some View {
        VStack {
            ZStack
            {
                ScrollView {
                    if cartVM.products.isEmpty {
                        VStack{
                            Spacer()
                            Text("No products in cart")
                            Spacer()
                        }.background(Color.timberwolf)
                    } else {
                        VStack {
                            ForEach(cartVM.products) { product in
                                ProductCartView(product: product)
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color.timberwolf)
                .navigationTitle("Cart")
                
            }
            ZStack {
                Spacer()
                NavigationLink(destination: CheckoutView(), label: {
                    HStack {
                        Image(systemName: "text.page.fill")
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                        Text("Place orders")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.fernGreen)
                    .cornerRadius(10)
                    .padding(.horizontal)
                })

            }
        }.background(Color.timberwolf)
    }
}
