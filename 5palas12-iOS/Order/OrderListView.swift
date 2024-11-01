import SwiftUI
import FirebaseAnalytics

struct OrdersListView: View {
    @EnvironmentObject var ordersVM: OrdersViewModel
    @State private var enterTime: Date? = nil
    
    private var userEmail: String? {
        UserDefaults.standard.string(forKey: "currentUserEmail")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LogoView()
                    .padding(.all, 0)
                ScrollView {
                    VStack(spacing: 16) {
                        if let email = userEmail {
                            ForEach(ordersVM.orders) { order in
                                OrderCardView(order: order)
                            }
                        } else {
                            Text("No user email found.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding()
                }
                .background(Color("Timberwolf"))
            }
            .onAppear {
                if let email = userEmail {
                    ordersVM.fetchOrders(byUserEmail: email)
                    enterTime = Date()
                }
            }
            .onDisappear {
                if let enterTime = enterTime {
                    let elapsedTime = Date().timeIntervalSince(enterTime)
                    print("User was in the OrdersListView for \(elapsedTime) seconds.")
                    logTimeFirebase(viewName: "OrdersListView", timeSpent: elapsedTime)
                }
            }
        }
    }
}

