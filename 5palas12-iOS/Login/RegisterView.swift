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
    
    @State var name: String = ""
    @State var surname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var isBusiness: Bool = false
    @State var showPassword: Bool = false
    @FocusState private var inFocus: Field?
    @State private var navigateToAdditionalInfo = false
    
    enum Field {
        case email, plain, secure
    }
    
    var isRegisterDisabled: Bool {
            [email, password, name].contains(where: \.isEmpty) || (!isBusiness && surname.isEmpty)
        }
    
    var body : some View {
        NavigationView{
            VStack(alignment: .leading, spacing:12) {
                
                
                Spacer()
                Text("Join us!")
                    .padding()
                    .font(.system(size: 60))
                    .padding(.bottom, -20)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                HStack {
                    Text("at ")
                        .font(.system(size: 30))
                        .foregroundColor(.black) // Change color if needed
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
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray,lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                TextField("Surname", text:$surname)
                    .autocapitalization(.words)
                    .padding(10)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray,lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
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
                
                Button {
                    register() // Call the register function
                } label: {
                    Text("Register")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(isRegisterDisabled ? .gray : Color(hex: "#588157"))
                .cornerRadius(8)
                .disabled(isRegisterDisabled)
                .padding()
                
                Spacer()
            }
            NavigationLink(destination: AdditionalInfoView(), isActive: $navigateToAdditionalInfo) {
                EmptyView() // No muestra nada visual, solo se usa para navegar
            }
        }
    }
    private func register() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error during registration: \(error.localizedDescription)")
                return
            }

            // Si el registro fue exitoso, redirigimos a la pantalla adicional
            if let user = authResult?.user {
                print("User \(user.uid) registered successfully!")
                navigateToAdditionalInfo = true // Activa la navegación
            }
        }
    }

}


