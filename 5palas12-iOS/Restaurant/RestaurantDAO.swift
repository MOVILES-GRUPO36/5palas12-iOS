//
//  RestaurantDAO.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 13/10/24.
//

import FirebaseFirestore

class RestaurantDAO {
    private let db = FirestoreManager.shared.db
    private let collectionName = "restaurants"
    
    func addRestaurant(_ restaurant: RestaurantModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let restaurantData: [String: Any] = [
            "name": restaurant.name,
            "latitude": restaurant.latitude,
            "longitude": restaurant.longitude,
            "photo": restaurant.photo,
            "categories": restaurant.categories,
            "description": restaurant.description,
            "rating": restaurant.rating,
            "address": restaurant.address
        ]
        
        db.collection(collectionName).addDocument(data: restaurantData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAllRestaurants(completion: @escaping (Result<[RestaurantModel], Error>) -> Void) {
        db.collection("restaurants").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var restaurants: [RestaurantModel] = []
                for document in snapshot!.documents {
                    do {
                        let restaurant = try document.data(as: RestaurantModel.self)
                        restaurants.append(restaurant)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(restaurants))
            }
        }
    }
}

