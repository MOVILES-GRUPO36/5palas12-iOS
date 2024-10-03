import SwiftUI

struct RestaurantsCloseToYou: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab = 0
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationView {
                VStack {
                    // App Bar Title
                    VStack(spacing: 0){
                        LogoView()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.15)
                            .padding(0)
                        // List of restaurant cards in a ScrollView
                        ScrollView {
                            VStack(spacing: 16) {
                                ForEach(locationManager.nearbyRestaurants) { restaurant in
                                    RestaurantCardView(restaurant: restaurant)
                                }
                            }
                            .padding()
                        }
                        
                        
                    }
                }
                .onAppear {
                    // Store the time the view appears
                    enterTime = Date()
                    locationManager.fetchNearbyRestaurants() // Fetch restaurants on view appearance
                }
                .onDisappear {
                    // Calculate how long the user stayed on the view
                    if let enterTime = enterTime {
                        let elapsedTime = Date().timeIntervalSince(enterTime)
                        print("User stayed in the view for \(elapsedTime) seconds.")
                    }
            }
        }
    }
    
}
