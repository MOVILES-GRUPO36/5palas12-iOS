//
//  OrderViewModel.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import Foundation
import Combine
import Network

class OrdersViewModel: ObservableObject {
    private let orderDAO = OrderDAO() // Instancia del DAO para manejar la lógica de datos
    @Published var orders: [OrderModel] = [] // Almacena las órdenes obtenidas
    @Published var errorMessage: String? // Para mostrar errores en la vista
    @Published var isLoading: Bool = false // Indica si estamos cargando datos
    private var cancellables = Set<AnyCancellable>() // Para gestionar las suscripciones de Combine
  

    // MARK: - Obtener órdenes por email
    func fetchOrders(byUserEmail email: String) {
        print("Starting fetchOrders on thread: \(Thread.current)") // Log thread at the start
        
        // Dispatch fetching logic to a background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            print("Fetching data on thread: \(Thread.current)") // Log thread where data is fetched
            
            self?.orderDAO.getAllOrders(byUserEmail: email) { result in
                
                // Switch back to the main thread for UI updates
                DispatchQueue.main.async { [weak self] in
                    print("Updating UI on thread: \(Thread.current)") // Log thread for UI update
                    
                    switch result {
                    case .success(let orders):
                        self?.orders = orders
                        self?.errorMessage = nil
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                    
                    self?.isLoading = false // Update the loading state
                }
            }
        }
    }
    
    // MARK: - Cargar órdenes locales
    func loadLocalOrders() {
        isLoading = true
        orderDAO.loadLocalOrders { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let orders):
                self?.orders = orders
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Crear una nueva orden
    func createOrder(userEmail: String, products: [String], price: Double, isActive: Bool, pickUpTime: String, restaurantName: String) {
            let newOrderNumber = Double.random(in: 1000...9999)
            let newOrder = OrderModel(orderNumber: newOrderNumber, userEmail: userEmail, products: products, price: price, isActive: isActive, pickUpTime: pickUpTime, restaurantName: restaurantName)
                orderDAO.createOrder(newOrder) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self?.fetchOrders(byUserEmail: userEmail)
                        case .failure(let error):
                            self?.errorMessage = "Failed to create order: \(error.localizedDescription)"
                        }
                    }
                }
            
        }
    
    // MARK: - Guardar órdenes localmente
    func saveOrdersLocally() {
        orderDAO.saveOrdersLocally(orders)
    }
    
    // MARK: - Cargar órdenes locales al iniciar
    func loadInitialOrders() {
        if let email = UserDefaults.standard.string(forKey: "currentUserEmail") {
            fetchOrders(byUserEmail: email)
        } else {
            self.orders = []  // Si no hay email, limpiar las órdenes
        }
    }
    
    // MARK: - Borrar las órdenes locales
    func DeleteOrdersFile() {
        orderDAO.deleteLocalOrdersFile()
        self.orders = []  // Limpiar las órdenes en memoria
    }
}
