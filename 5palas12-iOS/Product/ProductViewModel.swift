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
    
    private let productDAO = ProductDAO()
    
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        fetchProductsbyRestaurant(restaurant: restaurant)
    }
    
    func fetchProductsbyRestaurant(restaurant: RestaurantModel) {
        productDAO.getProductsbyRestaurant(restaurant: restaurant) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.products = products
                    print("Products fetched")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = "Error al cargar productos desde Firestore: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "Error desconocido")
                }
            }
        }
    }
    
    func addProduct(_ product: ProductModel, completion: @escaping (Bool) -> Void) {
        productDAO.addProduct(product, for: restaurant) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.products.append(product)
                    print("Product added successfully")
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error al agregar producto a Firestore."
                }
            }
            completion(success)
        }
    }
}
