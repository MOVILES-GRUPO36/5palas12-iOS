//
//  ProductViewModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

import Foundation

class ProductViewModel: ObservableObject {
    var restaurant: RestaurantModel
    @Published var products: [ProductModel] = []
    @Published var errorMessage: String? = nil
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        fetchProductsbyRestaurant(restaurant: restaurant)
    }
    private let productDAO = ProductDAO()
    
    func fetchProductsbyRestaurant(restaurant: RestaurantModel) {
        productDAO.getProductsbyRestaurant(restaurant: restaurant) { [weak self] result in
            switch result {
                
            case .success(let products):
                self?.products = products
                print("Products fetched")
            case .failure(let error):
                self?.errorMessage = "Error al cargar restaurantes desde Firestore: \(error.localizedDescription)"
                print(self?.errorMessage ?? "Error desconocido")
            }
        }
    }
}
