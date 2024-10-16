import SwiftUI

struct RestaurantsListView: View {
    @StateObject private var locationManager = LocationManager()
    @ObservedObject var restaurantsVM: RestaurantViewModel
    @State private var selectedTab = 0
    @State private var enterTime: Date? = nil // Variable to store the time the view appears
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0){
                    LogoView()
                        .padding(.all,0)
                    ScrollView {
                            VStack(spacing: 16) {
                                ForEach(sortedRestaurants) { restaurant in
                                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                        RestaurantCardView(restaurant: restaurant)
                                    }.accentColor(.black)
                                        .navigationBarBackButtonHidden(true)
                                }
                            }
                            .padding()
                    
                    
                    
                    }.background(Color("Timberwolf"))
            }
        }
                .onDisappear {
                    // Calculate how long the user stayed on the view
                    if let enterTime = enterTime {
                        let elapsedTime = Date().timeIntervalSince(enterTime)
                        print("User stayed in the view for \(elapsedTime) seconds.")
                    }
                }
            
        }
        
    private var sortedRestaurants: [RestaurantModel] {
            return restaurantsVM.restaurants.sorted { (restaurant1, restaurant2) -> Bool in
                guard let distance1 = restaurant1.distance, let distance2 = restaurant2.distance else {
                    return false
                }
                return distance1 < distance2
            }
        }
}
