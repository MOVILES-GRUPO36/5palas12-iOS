import FirebaseFirestore

class OrderDAO {
    private let db = FirestoreManager.shared.db
    private let collectionName = "orders"
    
    func createOrder(_ order: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let orderData: [String: Any] = [
            "userEmail": order.userEmail,
            "products": order.products,
            "price": order.price,
            "isActive": order.isActive,
            "pickUpTime": order.pickUpTime
        ]
        
        db.collection(collectionName).addDocument(data: orderData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAllOrders(byUserEmail email: String, completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        db.collection(collectionName).whereField("userEmail", isEqualTo: email).getDocuments { snapshot, error in
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
}

