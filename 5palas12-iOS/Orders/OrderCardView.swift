//
//  OrderCardView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import SwiftUI

struct OrderCardView: View {
    var order: OrderModel
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/2272/2272267.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle())
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Order Code \(order.id)")
                    .font(.headline)
                
                Text("Restaurant: \(order.restaurantName)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text("Products: \(order.products.joined(separator: ", "))")
                    .font(.subheadline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .opacity(0.7)
                
                Text("Total Price: $\(order.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Text("Pickup Time: \(order.pickUpTime)")
                    .font(.subheadline)
                    .opacity(0.6)
                
                if order.isActive {
                    Text("Status: Active")
                        .font(.caption)
                        .foregroundColor(.blue)
                } else {
                    Text("Status: Inactive")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
