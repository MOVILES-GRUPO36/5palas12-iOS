//
//  UserSettingsView.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import SwiftUI

struct UserSettingsView: View {
    @State private var settings: [SettingItem] = [
        SettingItem(title: "Notifications", icon: "bell", type: .toggle(true)),
        SettingItem(title: "Account", icon: "person.crop.circle", type: .navigation),
        SettingItem(title: "Privacy", icon: "lock.shield", type: .navigation),
        SettingItem(title: "Help & Support", icon: "questionmark.circle", type: .navigation),
        SettingItem(title: "About", icon: "info.circle", type: .navigation),
        SettingItem(title: "Logout", icon: "arrow.right.circle", type: .navigation),
        SettingItem(title: "Delete account", icon: "trash.circle", type: .navigation) // Delete account
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                LogoView()
                    .padding(.all, 0)
                
                ZStack {
                    // Set the background color for the entire view
                    Color(hex: "#E6E1DB")
                        .ignoresSafeArea()
                        .padding(.top, -10)
                    
                    List {
                        ForEach(settings) { item in
                            HStack {
                                if let iconName = item.icon {
                                    Image(systemName: iconName)
                                        .foregroundColor(item.title == "Delete account" ? .red : .blue) // Red for "Delete account"
                                }
                                
                                Text(item.title)
                                    .foregroundColor(item.title == "Delete account" ? .red : .primary) // Red text for "Delete account"
                                
                                Spacer()
                                
                                switch item.type {
                                case .toggle(let isOn):
                                    Toggle("", isOn: .constant(isOn))
                                        .labelsHidden() // Hide the toggle label
                                case .navigation:
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                case .plain:
                                    EmptyView() // No action required
                                }
                            }
                            .padding(12) // Add padding around each item
                            .background(
                                RoundedRectangle(cornerRadius: 8) // Add rounded corners
                                    .fill(Color.white) // Background color for each item
//                                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2) // Optional: Add shadow
                            )
//                            .padding(.vertical, 5) // Add vertical spacing between items
                            .onTapGesture {
                                if case .navigation = item.type {
                                    // Handle navigation to another view
                                    print("Navigate to \(item.title)")
                                }
                            }
                        }
                        .listRowBackground(Color.clear) // Make the row background transparent
                    }
                    .listStyle(PlainListStyle()) // Optional: Change list style if needed
                    .background(Color.clear) // Set List background to clear
                    //.navigationBarTitleDisplayMode(.inline) // Uncomment if needed
//                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    UserSettingsView()
}
