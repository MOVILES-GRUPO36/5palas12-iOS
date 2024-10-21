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
                
                Spacer()
                
                Text("Welcome to Business Center")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                
                Spacer()
                
                
                ZStack {
                    Color(.timberwolf)
                        .ignoresSafeArea()
                        .padding(.top, 0)
                    
                    List {
                        ForEach(businessExists ? 1..<settings.count : 0..<1, id: \.self) { index in let item = settings[index]
                            HStack {
                                if let iconName = item.icon {
                                    Image(systemName: iconName)
                                        .foregroundColor(item.title == "Delete my business" ? .red : .blue)
                                }
                                
                                Text(item.title)
                                    .foregroundColor(item.title == "Delete my business" ? .red : .primary)
                                
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
