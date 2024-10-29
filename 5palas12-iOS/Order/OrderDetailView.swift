import SwiftUI

struct OrderDetailView: View {
    let order: OrderModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order #\(order.order_id)")
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
                Text("Product ID: \(productId.uuidString)")
                    .font(.body)
                    .padding(6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(6)
            }

            HStack {
                Text("Total Price:")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#584C3F"))
                Spacer()
                Text(String(format: "$%.2f", order.total_price))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#228B22"))
            }
            .padding(.vertical)

            HStack {
                Text("Estimated Time:")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#584C3F"))
                Spacer()
                Text(order.estimated_time)
                    .font(.headline)
                    .foregroundColor(Color(hex: "#584C3F").opacity(0.7))
            }

            Spacer()
        }
        .padding()
        .background(Color(hex: "#F5F5F5"))
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
