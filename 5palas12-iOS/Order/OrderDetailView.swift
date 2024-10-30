import SwiftUI

struct OrderDetailView: View {
    let order: OrderModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Order #\(order.id?.uuidString ?? "Unknown")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#228B22"))

                Text("Restaurant ID: \(order.restaurant_id)")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#584C3F"))

                Text("Products:")
                    .font(.title2)
                    .padding(.top)
                    .foregroundColor(Color(hex: "#584C3F"))

                ForEach(order.product_ids, id: \.self) { productId in
                    Text("Product ID: \(productId)")
                        .font(.body)
                        .padding(6)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(6)
                }

                HStack {
                    Text("Pickup Time:")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#584C3F"))
                    Spacer()
                    Text(order.pickupTime)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#584C3F").opacity(0.7))
                }
            }
            .padding()
            .background(Color(hex: "#F5F5F5"))
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

