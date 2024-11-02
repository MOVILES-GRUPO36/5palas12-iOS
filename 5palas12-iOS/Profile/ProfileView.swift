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
    @State private var name: String = "Set name"
    @State private var email: String = "Set email"
    @State private var enterTime: Date? = nil
    @EnvironmentObject var userVM: UserViewModel
    @State private var navigateToLogin = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                // Profile Info
                LogoView()
                    .padding(.all,0)
                
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
                
                Button {
                    //Text("huh")
                } label: {
                    Text("Business center")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#588157"))
                .cornerRadius(8)
                .padding()
                
                Button {
                    //Text("huh")
                } label: {
                    Text("My orders")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#588157"))
                .cornerRadius(8)
                .padding()
                
                NavigationLink(destination: UserSettingsView()) {
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
                                    logout() // Perform the logout action
                                })
                
                
                
                
            }
                               
        }
        //.navigationBarBackButtonHidden()
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
                print("El usuario estuvo en la vista por \(elapsedTime) segundos.")
                logTimeFirebase(viewName: "ProfileView", timeSpent: elapsedTime)
            }
        }
    }
    
    
    
    private func editProfile() {
        // Your logic to navigate to the edit profile view or to handle editing
        print("Edit profile tapped")
        // You could present a modal or navigate to another view here
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        isLoggedIn = false
        userVM.userData = nil
        print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        print(UserDefaults.standard.string(forKey: "currentUserEmail"))
        
    }
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
    }
}

//#Preview {
//    ProfileView()
//}
