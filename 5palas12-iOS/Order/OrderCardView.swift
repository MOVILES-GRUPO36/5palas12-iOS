import SwiftUI

struct OrderCardView: View {
    var order: OrderModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Orden ID: \(order.id?.uuidString ?? "Unknown")")
                .font(.headline)
                .padding(.bottom, 2)

            Text("Restaurant: \(order.restaurant_id)")
                .font(.subheadline)
                .opacity(0.7)

            Spacer()

            NavigationLink(destination: OrderDetailView(order: order)) {
                Text("Details")
                    .bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
                    .background(Color(hex: "#228B22"))  // FernGreen fallback
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

