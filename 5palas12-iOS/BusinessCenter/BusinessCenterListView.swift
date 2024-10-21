//
//  BusinessCenterListView.swift
//  5palas12-iOS
//
//  Created by santiago on 20/10/2024.
//

import SwiftUI

struct BusinessCenterListView: View {
    @State private var businessExists: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var settings: [SettingItem] = [
        SettingItem(title: "Create a business", icon: "building", type: .navigation),
        SettingItem(title: "View and edit my business", icon: "pencil", type: .navigation),
        SettingItem(title: "My orders", icon: "cart", type: .navigation),
        SettingItem(title: "Help & Support", icon: "questionmark.circle", type: .navigation),
        SettingItem(title: "Delete my business", icon: "trash.circle", type: .navigation)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                LogoView()
                    .padding(.all, 0)
                
                Spacer() // Add Spacer to center the text vertically
                Spacer() // Add Spacer to center the text vertically
                               
                Text("Welcome to Business Center")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center) // Center-align the text
                    .foregroundColor(.black) // Set text color explicitly
                    .frame(maxWidth: .infinity) // Make sure the text fills the available width
                    .padding() // Optional: Add padding around the text
                               
                Spacer()
                    
                
                ZStack {
                    // Set the background color for the entire view
                    Color(.timberwolf)
                        .ignoresSafeArea()
                        .padding(.top, 0)
                    
                    List {
                        ForEach(businessExists ? 1..<settings.count : 0..<1, id: \.self) { index in let item = settings[index]
                            HStack {
                                if let iconName = item.icon {
                                    Image(systemName: iconName)
                                        .foregroundColor(item.title == "Delete my business" ? .red : .blue) // Red for "Delete account"
                                }
                                
                                Text(item.title)
                                    .foregroundColor(item.title == "Delete my business" ? .red : .primary) // Red text for "Delete account"
                                
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
            .background(Color.timberwolf)
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
    BusinessCenterListView()
}
