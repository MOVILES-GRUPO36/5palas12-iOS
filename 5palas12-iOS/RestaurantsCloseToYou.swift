import SwiftUI

struct RestaurantsCloseToYou: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // App Bar Title
                Text("Close To You")
                    .font(.largeTitle)
                    .padding(.top)
                
                // List of restaurant cards in a ScrollView
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(locationManager.nearbyRestaurants) { restaurant in
                            RestaurantCardView(restaurant: restaurant)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                TabBarView(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            locationManager.fetchNearbyRestaurants() // Fetch restaurants on view appearance
        }
    }
}
