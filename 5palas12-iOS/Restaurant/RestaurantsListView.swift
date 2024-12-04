import SwiftUI
import FirebaseAnalytics

struct RestaurantsListView: View {
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
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
                // Spacer to push the button to the bottom
                                Spacer()
                                
                                // Button to go to Food Info
                                NavigationLink(destination: NutritionView()) {
                                    HStack {
                                        Image(systemName: "message.fill")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 5)
                                        Text("Ask for Food Info")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.fernGreen)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                                .padding(.bottom, 20)
                            }
                        }
        .onAppear {
            locationManager.requestLocation()
            enterTime = Date()
            restaurantsVM.startDistanceUpdates()
        }
        .onDisappear {
            restaurantsVM.stopDistanceUpdates()
            if let enterTime = enterTime {
                let elapsedTime = Date().timeIntervalSince(enterTime)
                print("El usuario estuvo en la vista por \(elapsedTime) segundos.")
                logTimeFirebase(viewName: "RestaurantsListView", timeSpent: elapsedTime)
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
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
    }
}
