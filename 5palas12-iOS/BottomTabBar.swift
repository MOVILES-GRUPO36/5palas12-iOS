import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            Text("Home")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }.tag(0)
            
            // Search Tab
            Text("Search")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(1)
            
            // Maps Tab
            Text("Maps")
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Maps")
                }.tag(2)
            
            // Profile Tab
            Text("Profile")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }.tag(3)
        }
    }
}

