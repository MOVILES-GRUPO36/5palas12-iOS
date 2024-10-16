//
//  test.swift
//  5palas12-iOS
//
//  Created by santiago on 01/10/2024.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int
    @StateObject var viewModel = RestaurantViewModel()

    
    let tabBarHeight: CGFloat = 100 

    let cornerRadius: CGFloat = 8
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            switch selectedTab {
            case 0:
                RestaurantsCloseToYou()
            case 1:
                Text("Search")
            case 2:
                MapView(restaurantsVM: viewModel)
            case 3:
                Text("Profile")
            default:
                Text("Home")
            }
            Spacer()
            

            HStack {
                TabBarButton(icon: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabBarButton(icon: "magnifyingglass", title: "Search", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabBarButton(icon: "map.fill", title: "Maps", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
                TabBarButton(icon: "person.fill", title: "Profile", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }
            }
            .frame(height: tabBarHeight)
                        .background(Color(hex: "#584C3F"))
                        .cornerRadius(cornerRadius) 
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -2)

                        
        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear {
            viewModel.loadRestaurants()             }
    }
}

struct TabBarButton: View {
    var icon: String
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    @Previewable
    @State var selectedTab = 0
    return TabBarView(selectedTab: $selectedTab)
}
