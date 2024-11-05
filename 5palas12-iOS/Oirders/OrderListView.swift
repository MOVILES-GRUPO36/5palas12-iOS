//
//  OrderListView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import SwiftUI
import FirebaseAnalytics

struct OrdersListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var ordersVM: OrdersViewModel
    @EnvironmentObject var timeManager: TimeManager
    @State private var enterTime: Date? = nil
    @State private var showAlert = false
    @State private var timeRemaining = ""

    private var userEmail: String? {
        UserDefaults.standard.string(forKey: "currentUserEmail")
    }
    
    private var activePickupTimes: [String] {
        ordersVM.orders
            .filter { $0.isActive }
            .map { $0.pickUpTime }
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
        let earliestPickupDate = Calendar.current.date(from: components)!

        let now = Date()
        let timeDifference = earliestPickupDate.timeIntervalSince(now)
        
        guard timeDifference > 0 else { return nil }
        
        let hours = Int(timeDifference) / 3600
        let minutes = (Int(timeDifference) % 3600) / 60
        return "\(hours) hours and \(minutes) minutes"
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
                if let email = userEmail, ordersVM.orders.isEmpty {
                    ordersVM.fetchOrders(byUserEmail: email)
                    enterTime = Date()
                }
                
                Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
                    if let remainingTime = calculateTimeRemaining() {
                        timeRemaining = remainingTime
                        showAlert = true
                    }
                }
            }
            .onDisappear {
                if let enterTime = enterTime {
                    let elapsedTime = Date().timeIntervalSince(enterTime)
                    print("User was in the OrdersListView for \(elapsedTime) seconds.")
                    logTimeFirebase(viewName: "OrdersListView", timeSpent: elapsedTime)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Pickup Time Alert"),
                    message: Text("Time remaining for earliest pickup time: \(timeRemaining)"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }.navigationBarBackButtonHidden(true)
            .overlay(alignment: .topLeading){
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Timberwolf"))
                        Text("Back")
                            .foregroundColor(Color("Timberwolf"))
                    }
                }.offset(x: 10,y: 18)
                
            }
    }
}
