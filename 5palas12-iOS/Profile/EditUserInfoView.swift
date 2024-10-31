//
//  EditUserInfoView.swift
//  5palas12-iOS
//
//  Created by santiago on 20/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseAnalytics


struct EditUserInfoView: View {
    
    @State var name: String = ""
    @State var surname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var birthday: Date = Date()
    @State var showPassword: Bool = false
    @FocusState private var inFocus: Field?
    @State private var isSuccesful: Bool = false
    @State private var isBusinessError : Bool = false
    @State private var saveChangesResponse: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var enterTime: Date? = nil

    private let userDAO = UserDAO()
    
    enum Field {
        case email, plain, secure
    }
    
    var body : some View {
        NavigationStack{
            VStack{
                Text("User Profile")
                                    .font(.largeTitle)
                                    .bold()
                                    .padding(.top, 40)

                                Text("Edit your details")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 20)

                                Spacer()
                
                TextField("Name", text: $name)
                    .autocapitalization(.words)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2) // Gray border with rounded corners
                    )
                    .padding(.horizontal)
                
                
                TextField("Surname", text:$surname)
                    .autocapitalization(.words)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray,lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .disabled(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(10)
                    .overlay{
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray,lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                DatePicker("Select Birthdate", selection: $birthday, displayedComponents: .date)
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .padding(.horizontal)
                
                HStack {
                    if showPassword {
                        TextField("New Password", text: $password)
                            .focused($inFocus, equals: .plain)
                            
                    } else {
                        SecureField("New Password", text: $password)
                            .focused($inFocus, equals: .secure)
                            
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
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 2)
                }
                .padding(.horizontal)
                
                Button {
                    saveChanges()
                } label: {
                    Text("Save changes")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#588157"))
                .cornerRadius(8)
                .padding()
                .alert("User created", isPresented: $isSuccesful) {
                    Button("Ok", role: .cancel) {}
                } message : {
                    Text("User created successfully")
                }
                .alert("Error", isPresented: $isBusinessError) {
                    Button("Ok", role: .cancel) {}
                } message : {
                    Text(saveChangesResponse)
                }
                             
                
                
                Spacer()
            }
            .background(Color(hex: "#E6E1DB"))
        }
        .onAppear {
            enterTime = Date()
        }
        .onDisappear {
            if let enterTime = enterTime {
                let elapsedTime = Date().timeIntervalSince(enterTime)
                print("El usuario estuvo en la vista por \(elapsedTime) segundos.")
                logTimeFirebase(viewName: "EditUserInfoView", timeSpent: elapsedTime)
            }
        }
        .navigationBarBackButtonHidden(true)
            .overlay(alignment: .topLeading){
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.fernGreen)
                        Text("Back")
                            .foregroundColor(.fernGreen)
                    }
                }.offset(x: 10,y: 18)
                
            }
        .navigationBarTitleDisplayMode(.inline) // Set display mode
        .background(Color(hex: "#588157"))
        
    }
    
    private func saveChanges() {
        let updatedData: [String: Any] = [
                    "name": name,
                    "surname": surname,
                    "email": email,
                    "birthday": birthday,
                    // Include more fields if necessary
                ]

                // Assuming you have a way to get the user's ID, pass it to the update function
                guard let userId = Auth.auth().currentUser?.uid else {
                    print("User ID not found.")
                    return
                }

                userDAO.updateUser(userId: userId, with: updatedData) { result in
                    switch result {
                    case .success:
                        isSuccesful = true // Trigger success alert
                    case .failure(let error):
                        saveChangesResponse = error.localizedDescription // Capture the error message
                        isBusinessError = true // Trigger error alert
                    }
                }
    }
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
            Analytics.logEvent("view_time_spent", parameters: [
                "view_name": viewName,
                "time_spent": timeSpent
            ])
        }
    
}

//#Preview {
//    EditUserInfoView()
//}
