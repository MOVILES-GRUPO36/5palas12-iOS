import SwiftUI

struct FilteredRestaurantsView: View {
    let category: String
    let restaurants: [RestaurantModel]

    var body: some View {
        let filtered = restaurants.filter { $0.categories.contains(category) }

        VStack {
            if filtered.isEmpty {
                Text("No restaurants found for \(category)")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(filtered) { restaurant in
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                RestaurantCardView(restaurant: restaurant)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .navigationTitle(category)
    }
}

