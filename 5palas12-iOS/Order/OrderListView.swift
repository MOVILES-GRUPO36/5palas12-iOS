import SwiftUI

struct OrderListView: View {
    @State var profileId: String
    @StateObject var orderVM: OrderViewModel

    init(profileId: String) {
        _profileId = State(initialValue: profileId)
        _orderVM = StateObject(wrappedValue: OrderViewModel(profileId: profileId))
    }

    var body: some View {
        if orderVM.orders.isEmpty {
            Text("No Orders Available at the moment")
                .bold()
                .foregroundStyle(.red)
        } else {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(orderVM.orders) { order in
                            OrderCardView(order: order)
                        }
                    }
                    .padding(10)
                }
                .background(Color("Timberwolf"))
            }
        }
    }
}

