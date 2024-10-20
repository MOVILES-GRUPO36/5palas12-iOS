//
//  ProductDao.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

class ProductDAO {
    
    private let db = FirestoreManager.shared.db
    private let collectionName: String = "products"
    
    func getProductsbyRestaurant(restaurant:RestaurantModel, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("restaurant", isEqualTo: restaurant.name)
            .getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var products: [ProductModel] = []
                for document in snapshot!.documents {
                    do {
                        let product = try document.data(as: ProductModel.self)
                        products.append(product)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(products))
            }
        }
    }
}
