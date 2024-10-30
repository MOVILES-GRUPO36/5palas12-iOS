import Foundation
import Combine

class OrderViewModel: ObservableObject {
    @Published var orders: [OrderModel] = []
    @Published var errorMessage: String? = nil
    @Published var isOrderCreated: Bool = false

    private let orderDAO = OrderDAO()
    private let profileId: String

    // Initialization with the user's profile ID
    init(profileId: String) {
        self.profileId = profileId
        fetchOrdersByUser()
    }

    // Fetch orders by user
    func fetchOrdersByUser() {
        orderDAO.getOrdersByUser(profileId: profileId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    self?.orders = orders
                    print("Orders fetched successfully")
                case .failure(let error):
                    self?.errorMessage = "Error loading the orders: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "Error")
                }
            }
        }
    }

    // Create a new order
    func createOrder(order: OrderModel) {
        orderDAO.createOrder(order: order) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.isOrderCreated = true
                    print("Order created successfully")
                    self?.fetchOrdersByUser()  // Reload orders after creating a new one
                case .failure(let error):
                    self?.errorMessage = "Error creating the order: \(error.localizedDescription)"
                    print(self?.errorMessage ?? "Unknown error")
                }
            }
        }
    }
}

