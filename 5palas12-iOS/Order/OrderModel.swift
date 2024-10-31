import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

class OrderDAO {
    
    private let db = FirestoreManager.shared.db
    private let collectionName: String = "orders"

    // Obtener órdenes filtradas por usuario (profile_id)
    func getOrdersByUser(profileId: String, completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        db.collection(collectionName)
            .whereField("profile_id", isEqualTo: profileId)  // Filtrar por profile_id
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    var orders: [OrderModel] = []
                    for document in snapshot!.documents {
                        do {
                            let order = try document.data(as: OrderModel.self)
                            orders.append(order)
                        } catch {
                            completion(.failure(error))
                            return
                        }
                    }
                    completion(.success(orders))
                }
            }
    }

    // Crear una nueva orden
    func createOrder(order: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection(collectionName).document(order.order_id).setData(from: order) { error in
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
