import SwiftUI

struct SearchView: View {
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @State private var searchText = ""
    @State private var filteredRestaurants: [RestaurantModel] = []

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
                    CategoryGridView(categories: categories, restaurants: restaurantsVM.restaurants)
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
                restaurantsVM.loadRestaurants() // Load restaurants dynamically
                filteredRestaurants = restaurantsVM.restaurants
            }
            .onChange(of: restaurantsVM.restaurants) { newRestaurants in
                filterRestaurants()
            }
            .onChange(of: searchText) { _ in
                filterRestaurants()
            }
        }
    }

    func filterRestaurants() {
        let query = searchText.lowercased()
        if query.isEmpty {
            filteredRestaurants = restaurantsVM.restaurants
        } else {
            filteredRestaurants = restaurantsVM.restaurants.filter { restaurant in
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


