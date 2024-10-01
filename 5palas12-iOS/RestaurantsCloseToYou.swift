import SwiftUI

struct RestaurantsCloseToYou: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // App Bar Title
                Text("Restaurants Near You")
                    .font(.largeTitle)
                    .padding()
                
                // List of restaurant cards
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(locationManager.nearbyRestaurants) { restaurant in
                            RestaurantCardView(restaurant: restaurant)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Use the new BottomTabBar component
                BottomTabBar(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            locationManager.fetchNearbyRestaurants()
        }
    }
}

