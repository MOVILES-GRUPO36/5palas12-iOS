//
//  ProductDao.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//
import FirebaseFirestore

class ProductDAO {
    
    private let db = FirestoreManager.shared.db
    private let collectionName: String = "products"
    
    func getProductsbyRestaurant(restaurant: RestaurantModel, completion: @escaping (Result<[ProductModel], Error>) -> Void) {
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
    
    func addProduct(_ product: ProductModel, for restaurant: RestaurantModel, completion: @escaping (Bool) -> Void) {
        var productData = try? Firestore.Encoder().encode(product)
        productData?["restaurant"] = restaurant.name
        
        db.collection(collectionName).addDocument(data: productData ?? [:]) { error in
            if let error = error {
                print("Error adding product: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func getProductByName(_ name: String, completion: @escaping (Result<ProductModel, Error>) -> Void) {
            db.collection("products")
                .whereField("name", isEqualTo: name)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let document = snapshot?.documents.first else {
                        completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                        return
                    }
                    
                    do {
                        let product = try document.data(as: ProductModel.self)
                        completion(.success(product))
                    } catch {
                        completion(.failure(error))
                    }
                }
        }
}
