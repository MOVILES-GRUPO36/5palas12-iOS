import SwiftUI
import FirebaseAnalytics

struct SearchView: View {
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @State private var searchText = ""
    @State private var enterTime: Date? = nil
    @State private var filteredRestaurants: [RestaurantModel] = []
    @EnvironmentObject var userVM: UserViewModel

    private let categories: [(name: String, imageUrl: String)] = [
        ("Vegan", "https://picsum.photos/id/1011/300/200"),
        ("Sushi", "https://picsum.photos/id/1025/300/200"),
        ("Pizza", "https://picsum.photos/id/1060/300/200"),
        ("Fast Food", "https://picsum.photos/id/1070/300/200"),
        ("Desserts", "https://picsum.photos/id/1080/300/200"),
        ("Drinks", "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1714158008542-ace991ea197b")
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearch: filterRestaurants)
                    .padding()
                    .padding(.top, -15)
                    .padding(.bottom, -15)

                if searchText.isEmpty {
                    createButton(title: "Based on you", color: Color(hex: "#588157")) {
                        BasedOnYouView().environmentObject(userVM)
                    }
                    
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
                restaurantsVM.loadRestaurants()
                filteredRestaurants = restaurantsVM.restaurants
                enterTime = Date()
            }
            .onChange(of: restaurantsVM.restaurants) { newRestaurants in
                filterRestaurants()
            }
            .onChange(of: searchText) { _ in
                filterRestaurants()
            }
            .onDisappear {
                if let enterTime = enterTime {
                    let elapsedTime = Date().timeIntervalSince(enterTime)
                    print("El usuario estuvo en la vista por \(elapsedTime) segundos.")
                    logTimeFirebase(viewName: "SearchView", timeSpent: elapsedTime)
                }
            }
        }
        .background(Color(hex: "#E6E1DB"))
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
    
    private func createButton<Destination: View>(title: String, color: Color, @ViewBuilder destination: @escaping () -> Destination) -> some View {
        NavigationLink(destination: destination()) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(8)
                .padding()
        }
    }
    
    func logTimeFirebase(viewName: String, timeSpent: TimeInterval) {
        Analytics.logEvent("view_time_spent", parameters: [
            "view_name": viewName,
            "time_spent": timeSpent
        ])
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
    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .overlay(
                        Color.black.opacity(0.3)
                    )
            } else {
                ProgressView()
                    .frame(width: 150, height: 150)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .onAppear {
                        ImageManager.shared.getImage(for: imageUrl) { downloadedImage in
                            self.image = downloadedImage
                        }
                    }
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


