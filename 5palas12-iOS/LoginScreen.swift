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
                        
                
                
//                Image("Image") // Use the name without file extension
//                                .resizable()
//                                .aspectRatio(contentMode: .fit) // Adjust as needed
//                                .frame(width: 130) // Adjust width as needed
//                                .padding(.top, 50) // Add padding if needed
//                                .padding(.bottom, 100) // Add bottom padding to separate from other content
//                                .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("E-mail", text:$email)
                    .padding(10)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray,lineWidth: 2)
                    }
                    .padding(.horizontal)
                    
                
                if showPassword {
                    TextField("Password", text: $password)
                        .focused($inFocus, equals: .plain)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)

                } else {
                    SecureField("Password", text: $password)
                        .focused($inFocus, equals: .secure)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        
                }
                
                Button(showPassword ? "Hide Password" : "Show Password") {
                    self.showPassword.toggle()
                    inFocus = showPassword ? .plain : .secure
                }
                .font(.caption)
                .foregroundColor(.white)
                .frame(width: 130, height: 20)
                .background(.black)
                .cornerRadius(5)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                
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
                            .black
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
                .foregroundStyle(Color(.black))
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
    }
}


#Preview {
    LoginScreen()
}

