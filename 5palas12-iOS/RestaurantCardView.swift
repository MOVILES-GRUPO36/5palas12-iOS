import SwiftUI

struct RestaurantCardView: View {
    var restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(restaurant.name)
                .font(.headline)
            Text(restaurant.address)
                .font(.subheadline)
            Text("Distance: \(restaurant.distance, specifier: "%.2f") km")
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
