import SwiftUI

struct RestaurantCardView: View {
    var restaurant: RestaurantModel
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: restaurant.photo)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle())
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(restaurant.name)
                    .font(.headline)
                Text("\(restaurant.categories.joined(separator: " - "))")
                    .opacity(0.5)
                
                RatingView(rating: restaurant.rating)

                
                if let distance = restaurant.distance {
                    Text("Distance: \(distance, specifier: "%.2f") km")
                        .font(.subheadline)
                } else {
                    Text("Distance: N/A")
                        .font(.subheadline)
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

