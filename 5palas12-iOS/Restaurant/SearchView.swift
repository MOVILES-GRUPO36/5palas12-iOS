import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var filteredRestaurants: [RestaurantModel] = []

    private let restaurants: [RestaurantModel] = [
        RestaurantModel(name: "Green Bistro", latitude: 4.7109, longitude: -74.0721,
                        photo:"https://picsum.photos/200",
                        categories: ["Vegan", "Organic"], description: "Healthy vegan food",
                        rating: 4.5, address: "Bogotá", distance: 2.0),
        RestaurantModel(name: "Sushi Master", latitude: 4.7109, longitude: -74.0721,
                        photo:"https://picsum.photos/200",
                        categories: ["Japanese", "Sushi"], description: "Fresh sushi and sashimi",
                        rating: 4.7, address: "Bogotá", distance: 3.5),
        RestaurantModel(name: "Pizza Lovers", latitude: 4.7109, longitude: -74.0721,
                        photo:"https://picsum.photos/200",
                        categories: ["Italian", "Pizza"], description: "Wood-fired pizza",
                        rating: 4.2, address: "Bogotá", distance: 4.0)
    ]

    private let categories: [(name: String, imageUrl: String)] = [
        ("Vegan", "https://picsum.photos/id/1011/300/200"),
        ("Sushi", "https://picsum.photos/id/1025/300/200"),
        ("Pizza", "https://picsum.photos/id/1060/300/200"),
        ("Fast Food", "https://picsum.photos/id/1070/300/200"),
        ("Desserts", "https://picsum.photos/id/1080/300/200"),
        ("Drinks", "https://picsum.photos/id/1090/300/200")
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearch: filterRestaurants)
                    .padding()

                if searchText.isEmpty {
                    CategoryGridView(categories: categories, restaurants: restaurants)
                } else if filteredRestaurants.isEmpty {
                    Text("No results found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(filteredRestaurants) { restaurant in
                                NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                    RestaurantCardView(restaurant: restaurant)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Restaurants")
            .onAppear {
                filteredRestaurants = restaurants
            }
        }
    }

    func filterRestaurants() {
        if searchText.isEmpty {
            filteredRestaurants = restaurants
        } else {
            let query = searchText.lowercased()
            filteredRestaurants = restaurants.filter { restaurant in
                restaurant.name.lowercased().contains(query) ||
                restaurant.categories.contains { $0.lowercased().contains(query) }
            }
        }
    }
}

struct CategoryGridView: View {
    let categories: [(name: String, imageUrl: String)]
    let restaurants: [RestaurantModel]
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(categories, id: \.name) { category in
                    NavigationLink(
                        destination: FilteredRestaurantsView(category: category.name, restaurants: restaurants)
                    ) {
                        CategoryCard(name: category.name, imageUrl: category.imageUrl)
                    }
                }
            }
            .padding()
        }
    }
}

struct CategoryCard: View {
    let name: String
    let imageUrl: String

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3)
                    )
            } placeholder: {
                ProgressView().progressViewStyle(LinearProgressViewStyle())
            }

            Color(hex: "#228B22").opacity(0.5)

            Text(name)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(radius: 5)
        }
        .frame(width: 150, height: 150)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
