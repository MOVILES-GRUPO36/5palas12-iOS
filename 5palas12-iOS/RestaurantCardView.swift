import SwiftUI

struct RestaurantCardView: View {
    var restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            // Cargar imagen desde la URL usando AsyncImage
            AsyncImage(url: URL(string: restaurant.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped() // Asegura que la imagen no se salga del marco
            } placeholder: {
                // Placeholder mientras la imagen se carga
                ProgressView()
                    .frame(height: 150)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant.name)
                    .font(.headline)
                Text(restaurant.address)
                    .font(.subheadline)
                
                // Safely unwrap the optional distance
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

