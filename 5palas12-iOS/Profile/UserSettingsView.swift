//
//  UserSettingsView.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAuth

struct UserSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isLoggedIn: Bool
    @State private var settings: [SettingItem] = [
        SettingItem(title: "Notifications", icon: "bell", type: .toggle(true)),
        SettingItem(title: "Account", icon: "person.crop.circle", type: .navigation),
        SettingItem(title: "Privacy", icon: "lock.shield", type: .navigation),
        SettingItem(title: "Help & Support", icon: "questionmark.circle", type: .navigation),
        SettingItem(title: "About", icon: "info.circle", type: .navigation),
        SettingItem(title: "Logout", icon: "arrow.right.circle", type: .navigation),
        SettingItem(title: "Delete account", icon: "trash.circle", type: .navigation)
    ]
    @State private var enterTime: Date? = nil
    @State private var showDeleteAccountPrompt = false
    @State private var password = ""
    @State private var deletionError: String? = nil
    @State private var isLoading = false
    @State private var showTemporaryMessage = false 
    @EnvironmentObject var userVM: UserViewModel

    private let userDAO = UserDAO()

    var body: some View {
        NavigationView {
            VStack {
                headerView
                
                if showTemporaryMessage {
                    Text("Delete your restaurant first")
                        .font(.headline)
                        .foregroundColor(.red)
                        .transition(.opacity)
                        .padding()
                }
                
                settingsListView
            }
            .overlay(backButtonOverlay, alignment: .topLeading)
            .sheet(isPresented: $showDeleteAccountPrompt) {
                TextAlert(password: $password, action: confirmDeleteAccount)
            }
            .onAppear(perform: handleOnAppear)
            .onDisappear(perform: handleOnDisappear)
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        LogoView()
            .padding(.all, 0)
    }

    private var settingsListView: some View {
        ZStack {
            Color(hex: "#E6E1DB")
                .ignoresSafeArea()
                .padding(.top, -10)

            List {
                ForEach(settings) { item in
                    settingRow(item: item)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
        }
    }

    private func settingRow(item: SettingItem) -> some View {
        HStack {
            if let iconName = item.icon {
                Image(systemName: iconName)
                    .foregroundColor(item.title == "Delete account" ? .red : .blue)
            }

            Text(item.title)
                .foregroundColor(item.title == "Delete account" ? .red : .primary)

            Spacer()

            switch item.type {
            case .toggle(let isOn):
                Toggle("", isOn: .constant(isOn))
                    .labelsHidden()
            case .navigation:
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            case .plain:
                EmptyView()
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
        )
        .onTapGesture {
            handleRowTap(for: item)
        }
    }

    private var backButtonOverlay: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.timberwolf)
                Text("Back")
                    .foregroundColor(.timberwolf)
            }
        }
        .offset(x: 10, y: 18)
    }

    // MARK: - Actions

    private func handleRowTap(for item: SettingItem) {
        if item.title == "Delete account" {
            checkIfUserHasRestaurant()
        } else if item.title == "Logout" {
            logout()
            isLoggedIn = false
        }
    }

    private func checkIfUserHasRestaurant() {
        print("Checking if user has a restaurant...")

        if let restaurant = userVM.userData?.restaurant {
            print("User has a restaurant: \(restaurant)")

            showTemporaryMessage = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showTemporaryMessage = false
            }
        } else {
            print("User does not have a restaurant.")

            showDeleteAccountPrompt = true
        }
    }

    private func confirmDeleteAccount() {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            deletionError = "Unable to authenticate user."
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        isLoading = true  // Show the loading overlay

        // Perform reauthentication on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        deletionError = "Authentication failed: \(error.localizedDescription)"
                        isLoading = false
                    }
                    return
                }

                userDAO.deleteUserByEmail(email: email) { result in
                    switch result {
                    case .success:
                        user.delete { error in
                            DispatchQueue.main.async {
                                if let error = error {
                                    deletionError = "Failed to delete account: \(error.localizedDescription)"
                                } else {
                                    logout()
                                    isLoggedIn = false
                                }
                                isLoading = false
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            deletionError = "Failed to delete Firestore record: \(error.localizedDescription)"
                            isLoading = false
                        }
                    }
                }
            }
        }
    }

    private func handleOnAppear() {
        enterTime = Date()
    }

    private func handleOnDisappear() {
        if let enterTime = enterTime {
            let elapsedTime = Date().timeIntervalSince(enterTime)
            logTimeFirebase(viewName: "UserSettingsView", timeSpent: elapsedTime)
        }
    }

    private func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUserEmail")
        isLoggedIn = false
        OrderDAO().deleteLocalOrdersFile()
        JSONCCFileManager().deleteAllCreditCards()
    }

    private func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
    }
}

struct TextAlert: View {
    @Binding var password: String
    @State var showPassword: Bool = false
    @FocusState private var inFocus: Field?
    let action: () -> Void

    enum Field {
        case email, plain, secure
    }

    var body: some View {
        VStack(spacing: 20) {
            headerView
            instructionText
            passwordInputField
            actionButtons
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }

    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Are you sure you want to leave ")
                .font(.title)
                .fontWeight(.regular)

            HStack {
                Text("5 pa' las 12")
                    .font(.custom("Fascinate Inline", size: 30))
                    .fontWeight(.bold)
                    .foregroundStyle(Color(hex: "#588157"))
                Text("? :c")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.bottom, 20)
    }

    private var instructionText: some View {
        Text("Type your password once more to confirm your identity.")
            .font(.caption)
            .padding(.bottom, 10)
    }

    private var passwordInputField: some View {
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
    }

    private var actionButtons: some View {
        HStack(spacing: 40) {
            Button("Cancel") {
                password = ""
            }
            .padding()
            .frame(width: 120, height: 50)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Confirm") {
                action()
            }
            .padding()
            .frame(width: 120, height: 50)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
