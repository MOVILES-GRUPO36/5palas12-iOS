//
//  OfflineModeView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 4/11/24.
//

import SwiftUI
import FirebaseAnalytics

struct OfflineModeView: View {
    @State private var name: String = "Set name"
    @State private var email: String = "Set email"
    @EnvironmentObject var userVM: UserViewModel
    @State private var navigateToLogin = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showAlert = false

    
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Offline Mode")
                    .font(.title2)
                    .bold()
                    .padding()
                
                
                Spacer()
                NavigationLink(destination: AuthenticatedPaymentMethodsView()) {
                    Text("Payment Methods")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .accentColor(.fernGreen)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#588157"))
                .cornerRadius(8)
                .padding()
                
                
                NavigationLink(destination: OrdersListView()) {
                    Text("My orders")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .accentColor(.fernGreen)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#588157"))
                .cornerRadius(8)
                .padding()
                
                NavigationLink(destination: UserSettingsView(isLoggedIn: $isLoggedIn)) {
                    Text("Settings")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .accentColor(.fernGreen)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#588157"))
                .cornerRadius(8)
                .padding()
                
                NavigationLink(destination: LoginScreen(isLoggedIn: .constant(false))) {
                                    Text("Logout")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(height: 46)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                        .padding()
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
        }
    }
    
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        isLoggedIn = false
        userVM.userData = nil
        print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        print(UserDefaults.standard.string(forKey: "currentUserEmail"))
        
    }
    
}
