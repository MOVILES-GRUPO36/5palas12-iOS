import SwiftUI

struct RestaurantCardView: View {
    var restaurant: RestaurantModel
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: restaurant.photo)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
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
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        if index < Int(restaurant.rating) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color("FernGreen"))
                                .cornerRadius(4)
                        } else if index < Int(restaurant.rating + 0.5) {
                            Image(systemName: "star.leadinghalf.filled")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color("FernGreen"))
                                .cornerRadius(4)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color("FernGreen"))
                                .cornerRadius(4)
                        }
                    }
                }

                
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

