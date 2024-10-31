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
    @State private var name: String = "John Doe" // Replace with your dynamic user data
    @State private var email: String = "john.doe@example.com" // Replace with your dynamic user data
    @State private var enterTime: Date? = nil

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
                
                Button {
                    //Text("huh")
                } label: {
                    Text("Log out")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(.red)
                .cornerRadius(8)
                .padding()
                
                
            }
        }
        //.navigationBarBackButtonHidden()
        .background(Color(hex: "#E6E1DB"))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
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
