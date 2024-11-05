//
//  UserDAO.swift
//  5palas12-iOS
//
//  Created by santiago on 16/10/2024.
//

import FirebaseFirestore

class UserDAO {
    private let db = FirestoreManager.shared.db
    private let collectionName = "users"
    
    // Add a new user
    func addUser(_ user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "name": user.name,
            "surname": user.surname,
            "email": user.email,
            "birthday": user.birthday,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection(collectionName).addDocument(data: userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Get all users
    func getAllUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var users: [UserModel] = []
                for document in snapshot!.documents {
                    do {
                        let user = try document.data(as: UserModel.self)
                        users.append(user)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(users))
            }
        }
    }
    
    // Fetch a user by ID
    func getUserById(_ userId: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection(collectionName).document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot, snapshot.exists {
                do {
                    let user = try snapshot.data(as: UserModel.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
            }
        }
    }
    
    func getUserByEmail(email:String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        db.collection(collectionName)
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    for document in snapshot!.documents {
                        do {
                            let user = try document.data(as: UserModel.self)
                            completion(.success(user))
                        } catch {
                            completion(.failure(error))
                            return
                        }
                    }
                    
                }
            }
    }
    
    
    
    // Update a user's information
    func updateUser(userId: String, with updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(userId).updateData(updatedData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Delete a user by ID
    func deleteUser(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionName).document(userId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addRestaurantToUser(email: String, restaurantName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let usersCollection = db.collection(collectionName)
        
        // Query the user's document by email
        usersCollection.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                // Handle case where no document with the given email is found
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            // Get the document reference of the found user
            let userRef = document.reference
            
            // Set the "restaurant" field to the specified restaurant name (replacing any existing value)
            userRef.updateData([
                "restaurant": restaurantName
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func getUserByEmail(userEmail: String, completion: @escaping (Result<UserModel?, Error>) -> Void) {
            db.collection(collectionName)
                .whereField("email", isEqualTo: userEmail)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let document = snapshot?.documents.first {
                        do {
                            let user = try document.data(as: UserModel.self)
                            completion(.success(user))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.success(nil)) // No user found
                    }
                }
        }
}
