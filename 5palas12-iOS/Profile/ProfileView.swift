//
//  ProfileView.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import SwiftUI
import FirebaseAnalytics

struct ProfileView: View {
    private var userDAO : UserDAO = UserDAO()
    @StateObject private var businessCenterViewModel = BusinessCenterViewModel()
    @State private var name: String = "Set name"
    @State private var email: String = "Set email"
    @State private var enterTime: Date? = nil
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var restaurantVM: RestaurantViewModel
    @State private var navigateToLogin = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                // Profile Info
                LogoView()
                    .padding(.all, 0)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(name)")
                            .font(.title)
                        Text("\(email)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Edit icon
                    NavigationLink(destination: EditUserInfoView()) {
                        Image(systemName: "pencil")
                            .font(.title) // Adjust the font size as needed
                            .foregroundColor(.black) // Change color as needed
                    }
                    .padding(.trailing)
                }
                .padding()
                
                Spacer()
                
                createButton(title: "Payment Methods", color: Color(hex: "#588157")) {
                    AuthenticatedPaymentMethodsView()
                }
                
                if let restaurantName = userVM.userData?.restaurant {
                    createButton(title: "Business Center", color: Color(hex: "#588157")) {
                        BusinessCenterListView(
                            viewModel: businessCenterViewModel,
                            restaurant: restaurantVM.getRestaurantByName(name: restaurantName)!
                        )
                    }
                } else {
                    createButton(title: "Business Center", color: Color(hex: "#588157")) {
                        BusinessCenterListView(viewModel: businessCenterViewModel)
                    }
                }
                
                createButton(title: "My Orders", color: Color(hex: "#588157")) {
                    OrdersListView()
                }
                
                createButton(title: "Settings", color: Color(hex: "#588157")) {
                    UserSettingsView()
                }
                
                createButton(title: "Logout", color: Color.red) {
                    LoginScreen(isLoggedIn: .constant(false))
                }
                .simultaneousGesture(TapGesture().onEnded {
                    logout()
                })
                
            }
        }
        .background(Color(hex: "#E6E1DB"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let userData = userVM.userData {
                name = userData.name ?? "Set name"
                email = userData.email ?? "Set email"
            }
            enterTime = Date()
        }
        .onDisappear {
            if let enterTime = enterTime {
                let elapsedTime = Date().timeIntervalSince(enterTime)
                logTimeFirebase(viewName: "ProfileView", timeSpent: elapsedTime)
            }
        }
    }
    
    private func createButton<Destination: View>(title: String, color: Color, @ViewBuilder destination: @escaping () -> Destination) -> some View {
        NavigationLink(destination: destination()) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(height: 46) // Button height
                .frame(maxWidth: .infinity) // Button width
                .background(color) // Background color
                .cornerRadius(8) // Rounded corners
                .padding() // Padding around the button
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        isLoggedIn = false
        userVM.userData = nil
        
        // Delete local orders file
        let orderDAO = OrderDAO()
        orderDAO.deleteLocalOrdersFile()
        
        let jsonCards = JSONCCFileManager()
        jsonCards.deleteAllCreditCards()
    }
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
    }
}
