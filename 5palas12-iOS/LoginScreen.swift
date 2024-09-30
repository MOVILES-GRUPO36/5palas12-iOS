//
//  LoginScreen.swift
//  5palas12-iOS
//
//  Created by santiago on 03/09/2024.
//

import SwiftUI

struct LoginScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @FocusState private var inFocus: Field?
    
    enum Field {
        case email, plain, secure
    }
    
    var isLogInDisabled: Bool{
        [email, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing:15) {
            
            
            Spacer()
            Text("Hi! Welcome")
                .padding()
                .font(.system(size: 60))
                .padding(.bottom, -50)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("to 5 pa' las 12!")
                .padding()
                .font(.system(size: 30))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 60)
            
            
            TextField("E-mail", text:$email)
                .padding(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
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
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 2)
            }
            .padding(.horizontal)
            
            Button{
                print("user is trying to log in.")
            } label: {
                Text("Log in")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
            }
            .frame(height:50)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(
                isLogInDisabled ?
                    .gray :
                    Color(hex: "#588157")
            )
            .cornerRadius(5)
            .disabled(isLogInDisabled)
            .padding()
            
            Button {
                print("Navigate to the registration page.")
            } label: {
                Text("Don't have an account? ") +
                Text("Register")
                    .fontWeight(.heavy)
                
            }
            .font(.caption)
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        .background(Color(hex: "#E6E1DB"))
        .edgesIgnoringSafeArea(.all)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


#Preview {
    LoginScreen()
}

