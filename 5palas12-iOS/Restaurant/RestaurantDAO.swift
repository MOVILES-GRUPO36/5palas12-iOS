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
    
    func getRestaurantByUserEmail(userEmail: String, completion: @escaping (Result<RestaurantModel?, Error>) -> Void) {
            db.collection(collectionName)
                .whereField("email", isEqualTo: userEmail) // Ensure this matches your Firestore schema
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let document = snapshot?.documents.first {
                        do {
                            let restaurant = try document.data(as: RestaurantModel.self)
                            completion(.success(restaurant))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.success(nil)) // No restaurant found for this email
                    }
                }
        }
    func deleteRestaurantByName(_ name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName)
            .whereField("name", isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let document = snapshot?.documents.first {
                    document.reference.delete { deleteError in
                        if let deleteError = deleteError {
                            completion(.failure(deleteError))
                        } else {
                            completion(.success(()))
                        }
                    }
                } else {
                    // No matching restaurant found
                    completion(.failure(NSError(domain: "RestaurantDAO", code: 404, userInfo: [NSLocalizedDescriptionKey: "Restaurant not found"])))
                }
            }
    }
    
    func getRestaurantByName(_ name: String, completion: @escaping (Result<RestaurantModel, Error>) -> Void) {
        db.collection(collectionName)
            .whereField("name", isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let document = snapshot?.documents.first {
                    do {
                        let restaurant = try document.data(as: RestaurantModel.self)
                        completion(.success(restaurant))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Restaurant not found"])))
                }
            }
    }
}
