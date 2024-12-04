//
//  OrderDAO.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import Foundation
import FirebaseFirestore
import Network

class OrderDAO {
    private let db = FirestoreManager.shared.db // Instancia de Firestore
    private let collectionName = "orders" // Nombre de la colección en Firestore
    private let localFileName = "orders.json" // Archivo local para almacenamiento de órdenes

    


    // MARK: - Obtener órdenes por email desde Firestore
    func getAllOrders(byUserEmail email: String, completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        if NetworkMonitor.shared.isConnected {
            // Si hay conexión, consulta Firestore
            db.collection(collectionName)
                .whereField("userEmail", isEqualTo: email) // Filtro por correo del usuario
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error)) // Retorna error si ocurre
                        return
                    }

                    guard let snapshot = snapshot else {
                        completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found."])))
                        return
                    }

                    print("Snapshot size: \(snapshot.documents.count)") // Print the number of documents found
                    
                    do {
                        // Mapear documentos de Firestore a OrderModel
                        let orders = try snapshot.documents.map { document -> OrderModel in
                            var data = document.data()
                            data["id"] = document.documentID // Agregar el ID del documento como propiedad
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            let order = try JSONDecoder().decode(OrderModel.self, from: jsonData)
                            return order
                        }
                        completion(.success(orders)) // Devuelve las órdenes al completar
                    } catch {
                        completion(.failure(error)) // Error al deserializar
                    }
                }
        } else {
            // Si no hay conexión, carga las órdenes locales
            loadLocalOrders(completion: completion)
        }
    }

    // MARK: - Cargar órdenes locales desde archivo
    func loadLocalOrders(completion: @escaping (Result<[OrderModel], Error>) -> Void) {
        let fileURL = getLocalFileURL()
        do {
            let data = try Data(contentsOf: fileURL) // Cargar datos del archivo local
            let orders = try JSONDecoder().decode([OrderModel].self, from: data) // Decodificar las órdenes
            completion(.success(orders)) // Devuelve las órdenes locales
        } catch {
            completion(.failure(error)) // Retorna error si no puede cargar los datos
        }
    }

    // MARK: - Guardar órdenes en Firestore
    func createOrder(_ order: OrderModel, completion: @escaping (Result<Void, Error>) -> Void) {
            if NetworkMonitor.shared.isConnected{
                db.collection(collectionName).addDocument(data: order.dictionaryRepresentation) { error in
                }
            }
        }

    // MARK: - Guardar órdenes localmente en archivo JSON
    func saveOrdersLocally(_ orders: [OrderModel]) {
        let activeOrders = orders.filter { $0.isActive } // Filtrar solo las órdenes activas
        let fileURL = getLocalFileURL()
        do {
            let data = try JSONEncoder().encode(activeOrders) // Codificar solo las órdenes activas
            try data.write(to: fileURL) // Guardar el archivo localmente
        } catch {
            print("Error al guardar órdenes localmente: \(error)") // Imprimir error si ocurre
        }
    }

    // MARK: - Guardar una orden localmente
    private func saveOrderLocally(_ order: OrderModel) {
        var currentOrders = loadLocalOrdersSync() // Cargar las órdenes locales
        currentOrders.append(order) // Añadir la nueva orden
        saveOrdersLocally(currentOrders) // Guardar las órdenes actualizadas
    }

    // MARK: - Obtener URL del archivo local
    private func getLocalFileURL() -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(localFileName)
    }

    // MARK: - Cargar órdenes locales de manera síncrona (para uso interno)
    private func loadLocalOrdersSync() -> [OrderModel] {
        let fileURL = getLocalFileURL()
        do {
            let data = try Data(contentsOf: fileURL) // Cargar datos del archivo
            let orders = try JSONDecoder().decode([OrderModel].self, from: data) // Decodificar las órdenes
            return orders
        } catch {
            return [] // Si no hay datos, retornar lista vacía
        }
    }
    
    func deleteLocalOrdersFile() {
        let fileURL = getLocalFileURL() // Obtener la URL del archivo local
        let fileManager = FileManager.default // Instancia del FileManager
        do {
            // Verificar si el archivo existe
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL) // Eliminar el archivo
                print("Archivo de órdenes local eliminado exitosamente.")
            } else {
                print("El archivo local no existe.")
            }
        } catch {
            print("Error al eliminar el archivo local: \(error)")
        }
    }
}

