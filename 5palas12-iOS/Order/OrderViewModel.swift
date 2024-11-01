import Foundation
import Combine

class OrdersViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    private let orderDAO = OrderDAO()
    
    func fetchOrders(byUserEmail email: String) {
        orderDAO.getAllOrders(byUserEmail: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    self?.orders = orders
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch orders: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createOrder(userEmail: String, products: [String], price: Double, isActive: Bool, pickUpTime: String) {
        let newOrder = OrderModel(userEmail: userEmail, products: products, price: price, isActive: isActive, pickUpTime: pickUpTime)
        
        orderDAO.createOrder(newOrder) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchOrders(byUserEmail: userEmail) // Refresh orders after adding
                case .failure(let error):
                    self?.errorMessage = "Failed to create order: \(error.localizedDescription)"
                }
            }
        }
    }
}


