import SwiftUI

struct CreateOrderView: View {
    @EnvironmentObject var ordersVM: OrdersViewModel
    @EnvironmentObject var restaurantsVM: RestaurantViewModel
    @StateObject private var productVM = ProductViewModel(restaurant: RestaurantModel(id: UUID(), name: "", latitude: 0.0, longitude: 0.0, photo: "", categories: [], description: "", rating: 0.0, address: ""))
    
    @State private var userEmail: String = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    @State private var selectedRestaurantName: String?  // Store restaurant name, not object
    @State private var selectedProduct: ProductModel?
    @State private var price: Double = 0.0
    @State private var isActive: Bool = true
    @State private var pickUpTime: String = "5PM"
    @State private var showSuccessMessage: Bool = false
    @State private var showErrorMessage: Bool = false
    
    let pickUpTimeOptions = ["5PM", "6PM", "7PM"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                LogoView()
                Text("Create New Order")
                    .font(.title)
                    .padding(.bottom, 20)
                
                Form {
                    Section(header: Text("Order Details")) {
                        
                        // Picker to select restaurant
                        Picker("Select Restaurant", selection: $selectedRestaurantName) {
                            Text("Choose a restaurant").tag(String?.none)
                            ForEach(restaurantsVM.restaurants, id: \.id) { restaurant in
                                Text(restaurant.name).tag(String?.some(restaurant.name))
                            }
                        }
                        .onChange(of: selectedRestaurantName) { newRestaurantName in
                            if let newRestaurantName = newRestaurantName {
                                // Fetch products for the selected restaurant
                                if let selectedRestaurant = restaurantsVM.restaurants.first(where: { $0.name == newRestaurantName }) {
                                    productVM.fetchProductsbyRestaurant(restaurant: selectedRestaurant)
                                }
                            }
                        }
                        
                        // Check if the selected restaurant has products
                        if let selectedRestaurantName = selectedRestaurantName {
                            if productVM.products.isEmpty {
                                Text("No products available for selected restaurant")
                                    .foregroundColor(.gray)
                            } else {
                                // Picker to select product from the selected restaurant
                                Picker("Select Product", selection: $selectedProduct) {
                                    Text("Choose a product").tag(ProductModel?.none)
                                    ForEach(productVM.products) { product in
                                        Text(product.name).tag(ProductModel?.some(product))
                                    }
                                }
                                .onChange(of: selectedProduct) { newProduct in
                                    if let newProduct = newProduct {
                                        price = newProduct.price
                                    }
                                }
                            }
                        }
                        
                        Toggle("Order Active", isOn: $isActive)
                        
                        Picker("Pick Up Time", selection: $pickUpTime) {
                            ForEach(pickUpTimeOptions, id: \.self) { time in
                                Text(time).tag(time)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    createOrder()
                }) {
                    Text("Submit Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#228B22"))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                
                if showSuccessMessage {
                    Text("Order created successfully!")
                        .foregroundColor(.green)
                        .padding(.top)
                }
                
                if showErrorMessage {
                    Text("Failed to create order. Please try again.")
                        .foregroundColor(.red)
                        .padding(.top)
                }
                
                Spacer()
            }
            .background(Color("Timberwolf"))
            .onAppear {
                // Ensure the restaurants are loaded when the view appears
                restaurantsVM.loadRestaurants()
            }
        }
    }
    
    private func createOrder() {
        guard let selectedProduct = selectedProduct, let selectedRestaurantName = selectedRestaurantName else {
            showErrorMessage = true
            return
        }
        
        let productNames = [selectedProduct.name]
        
        ordersVM.createOrder(
            userEmail: userEmail,
            products: productNames,
            price: selectedProduct.price,
            isActive: isActive,
            pickUpTime: pickUpTime,
            restaurantName: selectedRestaurantName
        )
        
        showSuccessMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showSuccessMessage = false
        }
    }
}
