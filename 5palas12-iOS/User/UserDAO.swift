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
    
    func getAllUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        db.collection("users").getDocuments { snapshot, error in
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
}

