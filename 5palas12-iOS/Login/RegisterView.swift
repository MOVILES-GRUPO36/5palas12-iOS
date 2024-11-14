//
//  RegisterView.swift
//  5palas12-iOS
//
//  Created by santiago on 16/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseAnalytics

struct RegisterView: View {
    
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isBusiness: Bool = false
    @State private var showPassword: Bool = false
    @State private var home: Int = 0
    @FocusState private var inFocus: Field?
    @State private var navigateToAdditionalInfo = false
    @State private var registerResponse: String = ""
    @State private var birthday = Date()
    @State private var isLoading: Bool = false // Loading state
    @Binding var isLoggedIn: Bool
    @State private var isSuccesful: Bool = false
    @State private var isBusinessError: Bool = false
    private let userDAO = UserDAO()
    
    enum Field {
        case email, plain, secure
    }
    
    var isRegisterDisabled: Bool {
        [email, password, name].contains(where: \.isEmpty) ||
        (!isBusiness && surname.isEmpty) ||
        !isOldEnough ||
        email.count > 40 ||
        password.count > 40 ||
        name.count > 40 ||
        surname.count > 40
    }
    
    var isOldEnough: Bool {
        let calendar = Calendar.current
        let age = calendar.dateComponents([.year], from: birthday, to: Date()).year ?? 0
        return age >= 18
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 12) {
                    
                    Spacer()
                    Text("Join us!")
                        .padding()
                        .font(.system(size: 60))
                        .padding(.bottom, -20)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Text("at ")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                        Text("5 pa' las 12")
                            .font(.custom("Fascinate Inline", size: 30))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "#588157"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 80)
                    
                    TextField("Name", text: $name)
                        .autocapitalization(.words)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .onChange(of: name) { newValue in
                            if newValue.count > 40 { name = String(newValue.prefix(40)) }
                        }
                    
                    TextField("Surname", text: $surname)
                        .autocapitalization(.words)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .onChange(of: surname) { newValue in
                            if newValue.count > 40 { surname = String(newValue.prefix(40)) }
                        }
                    
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .onChange(of: email) { newValue in
                            if newValue.count > 40 { email = String(newValue.prefix(40)) }
                        }
                    
                    DatePicker("Select Birthdate", selection: $birthday, displayedComponents: .date)
                        .foregroundColor(.gray)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 2)
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
                    .onChange(of: password) { newValue in
                        if newValue.count > 40 { password = String(newValue.prefix(40)) }
                    }
                    
                    Button {
                        register()
                    } label: {
                        Text(isOldEnough ? "Register" : "You have to be 18 years or older")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(isRegisterDisabled ? .gray : Color(hex: "#588157"))
                    .cornerRadius(8)
                    .disabled(isRegisterDisabled)
                    .padding()
                    .alert("User created", isPresented: $isSuccesful) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text("User created successfully")
                    }
                    .alert("Error", isPresented: $isBusinessError) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text(registerResponse)
                    }
                    
                    Spacer()
                }
                
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.4) // Semi-transparent background
                            .ignoresSafeArea()
                        
                        VStack {
                            ProgressView("Hang tight!")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 10)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            
            NavigationLink(destination: LoginScreen(isLoggedIn: $isLoggedIn), isActive: $navigateToAdditionalInfo) {
                Text("")
            }
            .hidden()
        }
        .navigationBarBackButtonHidden()
    }
    
    private func register() {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                isLoading = false
                isBusinessError = true
                registerResponse = "\(error.localizedDescription)"
                return
            }
            
            let userId = UUID().uuidString
            let user = UserModel(
                id: userId,
                name: name,
                surname: surname,
                email: email,
                birthday: birthday,
                createdAt: Date()
            )
            
            self.userDAO.addUser(user) { result in
                isLoading = false
                switch result {
                case .success():
                    navigateToAdditionalInfo = true
                    isSuccesful = true
                case .failure(let error):
                    registerResponse = "Firestore Error: \(error.localizedDescription)"
                    isBusinessError = true
                }
            }
        }
    }
}
