import SwiftUI
import FirebaseAnalytics
import Charts

struct OrdersListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ordersVM: OrdersViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var timeManager: TimeManager
    @State private var enterTime: Date? = nil
    @State private var showAlert = false
    @State private var timeRemaining = ""
    @State private var timer: Timer? = nil
    @State private var chartData: [CategoryData] = []
    
    struct CategoryData: Identifiable {
        let id = UUID()
        let category: String
        let count: Int
    }
    
    private func categoryDistribution() -> [String: Int] {
        var categoryCount: [String: Int] = [:]
        for order in ordersVM.orders {
            for product in order.products {
                let category = product
                categoryCount[category, default: 0] += 1
            }
        }
        return categoryCount
    }
    
    private func calculateTimeRemaining() -> String? {
        let pickupTimes: [String: Int] = ["5PM": 17, "6PM": 18, "7PM": 19]
        guard let earliestPickup = activePickupTimes.min(),
              let hour = pickupTimes[earliestPickup] else {
            return nil
        }
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = 0
        var earliestPickupDate = Calendar.current.date(from: components)!
        let now = Date()
        if earliestPickupDate <= now {
            earliestPickupDate = Calendar.current.date(byAdding: .day, value: 1, to: earliestPickupDate)!
        }
        let timeDifference = earliestPickupDate.timeIntervalSince(now)
        let hours = Int(timeDifference) / 3600
        let minutes = (Int(timeDifference) % 3600) / 60
        return "\(hours) hours and \(minutes) minutes"
    }
    
    private var activePickupTimes: [String] {
        ordersVM.orders
            .filter { $0.isActive }
            .map { $0.pickUpTime }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LogoView()
                    .padding(.all, 0)
                
                ScrollView {
                    if !chartData.isEmpty {
                        VStack {
                            Text("Your favourite food ❤️")
                                .font(.headline)
                                .padding(.top)
                            
                            Chart(chartData) { data in
                                SectorMark(
                                    angle: .value("Count", data.count),
                                    innerRadius: .ratio(0.6),
                                    outerRadius: .ratio(1.0)
                                )
                                .foregroundStyle(by: .value("Category", data.category))
                            }
                            .chartLegend(.visible)
                            .frame(height: 250)
                            .padding()
                        }
                    }
                    VStack(spacing: 16) {
                        ForEach(ordersVM.orders) { order in
                            OrderCardView(order: order)
                        }
                        NavigationLink(destination: CreateOrderView()) {
                            Text("Create New Order")
                                .font(.headline)
                                .padding()
                                .background(Color(hex: "#228B22"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                }
                .background(Color("Timberwolf"))
            }
            .onAppear {
                if let userEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
                    ordersVM.fetchOrders(byUserEmail: userEmail)
                }
                
                enterTime = Date()
            }
            .onDisappear {
                if let enterTime = enterTime {
                    let elapsedTime = Date().timeIntervalSince(enterTime)
                    print("User was in the view for \(elapsedTime) seconds.")
                    
                    FirebaseLogger.shared.logTimeFirebase(viewName: "OrderListView", timeSpent: elapsedTime)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Pickup Time Alert"),
                    message: Text("Time remaining for earliest pickup time: \(timeRemaining)"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Timberwolf"))
                    Text("Back")
                        .foregroundColor(Color("Timberwolf"))
                }
            }
    }
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
    }
}
