//
//  test.swift
//  5palas12-iOS
//
//  Created by santiago on 01/10/2024.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    

    
    let tabBarHeight: CGFloat = 100 
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        NavigationView {
            
            
            
            VStack(spacing: 0) {
                
                
                switch selectedTab {
                case 0:
                    RestaurantsListView()
                        .padding(.all,0)
                    
                case 1:
                    Text("Search")
                case 2:
                    MapView()
                        .padding(.all,0)
                case 3:
                    ProfileView()
                        .padding(.all,0)
                default:
                    RestaurantsListView()
                        .padding(.all,0)
                }
                
                
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
                restaurantsVM.loadRestaurants()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
        
}



#Preview {
    @Previewable
    @State var selectedTab = 0
    return TabBarView(selectedTab: $selectedTab)
}
