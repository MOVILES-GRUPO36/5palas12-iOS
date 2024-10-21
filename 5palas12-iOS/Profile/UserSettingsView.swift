//
//  UserSettingsView.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import SwiftUI

struct UserSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var settings: [SettingItem] = [
        SettingItem(title: "Notifications", icon: "bell", type: .toggle(true)),
        SettingItem(title: "Account", icon: "person.crop.circle", type: .navigation),
        SettingItem(title: "Privacy", icon: "lock.shield", type: .navigation),
        SettingItem(title: "Help & Support", icon: "questionmark.circle", type: .navigation),
        SettingItem(title: "About", icon: "info.circle", type: .navigation),
        SettingItem(title: "Logout", icon: "arrow.right.circle", type: .navigation),
        SettingItem(title: "Delete account", icon: "trash.circle", type: .navigation)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                LogoView()
                    .padding(.all, 0)
                
                ZStack {
                    Color(hex: "#E6E1DB")
                        .ignoresSafeArea()
                        .padding(.top, -10)
                    
                    List {
                        ForEach(settings) { item in
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
                                if case .navigation = item.type {
                                    print("Navigate to \(item.title)")
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading){
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.timberwolf)
                    Text("Back")
                        .foregroundColor(.timberwolf)
                }
            }.offset(x: 10,y: 18)
            
        }
    }
}

#Preview {
    UserSettingsView()
}
