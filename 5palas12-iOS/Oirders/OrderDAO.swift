//
//  OrderDAO.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import FirebaseFirestore
import Foundation
import Network

class OrderDAO {
    private let db = FirestoreManager.shared.db
    private let collectionName = "orders"
    private let localFileName = "orders.json"
    
    private var monitor: NWPathMonitor!
    private var isConnected: Bool = true
    
    init() {
        setupNetworkMonitor()
    }
    
    func createOrder(_ order: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {
        if isConnected {
            db.collection(collectionName).addDocument(data: order.dictionaryRepresentation) { error in
                if let error = error {
                    // Guardar la orden en local si firebase falla
                    self.saveOrderLocally(order)
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            saveOrderLocally(order)
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Offline mode, order saved locally."])))
        }
    }
    
    func getAllOrders(byUserEmail email: String, completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        if isConnected {
            db.collection(collectionName).whereField("userEmail", isEqualTo: email).getDocuments { snapshot, error in
                if let error = error {
                    // Devolver ordenes locales
                    completion(.success(self.loadOrdersLocally()))
                } else {
                    var firestoreOrders: [OrderModel] = []
                    
                    for document in snapshot!.documents {
                        if let order = try? document.data(as: OrderModel.self) {
                            firestoreOrders.append(order)
                        }
                    }
                    
                    // Cargar locales y verificar duplicados
                    let localOrders = self.loadOrdersLocally()
                    let uniqueOrders = self.mergeUniqueOrders(firestoreOrders: firestoreOrders, localOrders: localOrders)
                    
                    // Guardar las ordenes unical en el almacenamiento local
                    self.saveOrdersToFile(uniqueOrders)
                    completion(.success(uniqueOrders))
                }
            }
        } else {
            // Offline: Cargar las ordenes locales
            completion(.success(loadOrdersLocally()))
        }
    }
    
    // Mezclar Firestore and local orders
    private func mergeUniqueOrders(firestoreOrders: [OrderModel], localOrders: [OrderModel]) -> [OrderModel] {
        var uniqueOrders = firestoreOrders

        for localOrder in localOrders {
            if !firestoreOrders.contains(where: { $0.restaurantName == localOrder.restaurantName }) {
                uniqueOrders.append(localOrder)
            }
        }
        
        return uniqueOrders
    }
    
    func saveOrderLocally(_ order: OrderModel) {
        var savedOrders = loadOrdersLocally()
        
        if !savedOrders.contains(where: { $0.restaurantName == order.restaurantName }) {
            savedOrders.append(order)
            saveOrdersToFile(savedOrders)
        }
    }
    
    func loadOrdersLocally() -> [OrderModel] {
        let fileURL = getDocumentsDirectory().appendingPathComponent(localFileName)
        guard let data = try? Data(contentsOf: fileURL),
              let orders = try? JSONDecoder().decode([OrderModel].self, from: data) else {
            return []
        }
        return orders
    }
    
    private func saveOrdersToFile(_ orders: [OrderModel]) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(localFileName)
        if let data = try? JSONEncoder().encode(orders) {
            try? data.write(to: fileURL)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func setupNetworkMonitor() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if self?.isConnected == true {
                self?.syncLocalOrdersToFirestore()
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func syncLocalOrdersToFirestore() {
        let localOrders = loadOrdersLocally()
        for order in localOrders {
            // Query Firestore to check if the order already exists
            db.collection(collectionName)
                .whereField("restaurantName", isEqualTo: order.restaurantName)
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error checking for duplicate order: \(error.localizedDescription)")
                        return
                    }
                    
                    // Check if there are any documents with the same restaurant name
                    if let snapshot = snapshot, snapshot.documents.isEmpty {
                        // No duplicate found, proceed to add the order
                        self.db.collection(self.collectionName).addDocument(data: order.dictionaryRepresentation) { error in
                            if error == nil {
                                // If successfully uploaded, remove the local copy
                                var remainingOrders = self.loadOrdersLocally()
                                remainingOrders.removeAll { $0.restaurantName == order.restaurantName }
                                self.saveOrdersToFile(remainingOrders)
                            }
                        }
                    } else {
                        // Duplicate found, skip adding this order
                        print("Duplicate order found for restaurant: \(order.restaurantName), skipping sync.")
                    }
                }
        }
    }
}
