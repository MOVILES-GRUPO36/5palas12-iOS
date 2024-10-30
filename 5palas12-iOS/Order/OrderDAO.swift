import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class OrderDAO {
    private let db = Firestore.firestore()
    private let collectionName = "orders"

    // Fetch orders by user profile ID
    func getOrdersByUser(profileId: String, completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("profile_id", isEqualTo: profileId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let orders = snapshot?.documents.compactMap { document in
                        try? document.data(as: OrderModel.self)
                    } ?? []
                    completion(.success(orders))
                }
            }
    }

    // Create a new order
    func createOrder(order: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try db.collection(collectionName).document(order.id.uuidString).setData(from: order) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
