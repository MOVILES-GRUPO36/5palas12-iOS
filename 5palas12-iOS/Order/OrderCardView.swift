import SwiftUI

struct OrderCardView: View {
    var order: OrderModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Orden ID: \(order.order_id)")
                .font(.headline)
                .padding(.bottom, 2)

            Text("Restaurant: \(order.restaurant_id)")
                .font(.subheadline)
                .opacity(0.7)
                .padding(.bottom, 2)

            Text("Total: $\(order.total_price, specifier: "%.2f")")
                .font(.title3)
                .bold()
                .padding(.bottom, 2)

            Text("Time Estimated: \(order.estimated_time)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 2)

            NavigationLink(destination: OrderDetailView(order: order)) {
                Text("Details")
                    .bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .background(Color("FernGreen"))
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

