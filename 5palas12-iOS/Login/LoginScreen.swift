//
//  LoginScreen.swift
//  5palas12-iOS
//
//  Created by santiago on 03/09/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseAnalytics


struct LoginScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @FocusState private var inFocus: Field?
    @State private var loginResponse: String = ""
    @Binding var isLoggedIn: Bool
    
    enum Field {
        case email, plain, secure
    }
    
    var isLogInDisabled: Bool{
        [email, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        NavigationView {
            
            
            VStack(alignment: .leading, spacing:12) {
                
                
                Spacer()
                Text("Hi! Welcome")
                    .padding()
                    .font(.system(size: 60))
                    .padding(.bottom, -20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                HStack {
                    Text("to ")
                        .font(.system(size: 30))
                        .foregroundColor(.black) // Change color if needed
                    Text("5 pa' las 12")
                        .font(.custom("Fascinate Inline", size: 30))
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "#588157"))
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 80)
                
                
                TextField("E-mail", text:$email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(10)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray,lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                
                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .focused($inFocus, equals: .plain)
                            .padding(10)
                    } else {
                        SecureField("Password", text: $password)
                            .focused($inFocus, equals: .secure)
                            .padding(10)
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                        inFocus = showPassword ? .plain : .secure
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                
                if !loginResponse.isEmpty {
                    Text(loginResponse)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Button {
                    login()
                } label: {
                    Text("Log in")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(isLogInDisabled ? .gray : Color(hex: "#588157"))
                .cornerRadius(8)
                .disabled(isLogInDisabled)
                .padding()
                
                
                HStack {
                    Spacer() // Add a leading spacer
                    NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                        Text("Don't have an account? ") +
                        Text("Register")
                            .fontWeight(.heavy)
                    }
                    Spacer() // Add a trailing spacer
                }
                .padding()
                
                Spacer()
                
                
            }
            .font(.caption)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top,-20)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .background(Color(hex: "#E6E1DB"))
        .edgesIgnoringSafeArea(.all)
    }
    
    
    
    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                loginResponse = "Error: \(error.localizedDescription)"
                return
            }
            
            loginResponse = "Login successful!"
            Analytics.logEvent("login", parameters: [
                "method": "email"
            ])
            isLoggedIn = true
        }
    }
    
}





