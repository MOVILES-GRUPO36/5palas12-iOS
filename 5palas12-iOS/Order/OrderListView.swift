import SwiftUI

struct OrderListView: View {
    @StateObject private var orderVM: OrderViewModel

    init(profileId: String) {
        _orderVM = StateObject(wrappedValue: OrderViewModel(profileId: profileId))
    }

    var body: some View {
        NavigationView {
            Group {
                if let errorMessage = orderVM.errorMessage {
                    Text("Error: \(errorMessage)")
                        .bold()
                        .foregroundColor(.red)
                } else if orderVM.orders.isEmpty {
                    Text("No Orders Available at the moment")
                        .bold()
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(orderVM.orders) { order in
                                OrderCardView(order: order)
                            }
                        }
                        .padding(10)
                    }
                    .background(Color("Timberwolf"))
                }
            }
            .navigationTitle("Your Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

