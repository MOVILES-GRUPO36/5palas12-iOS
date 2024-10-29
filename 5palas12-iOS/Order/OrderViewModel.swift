import Foundation

class OrderViewModel: ObservableObject {
    
    @Published var orders: [OrderModel] = []
    @Published var errorMessage: String? = nil
    @Published var isOrderCreated: Bool = false

    private let orderDAO = OrderDAO()
    private var profileId: String
    
    // Inicialización con el ID del perfil del usuario
    init(profileId: String) {
        self.profileId = profileId
        fetchOrdersByUser()
    }

    // Obtener órdenes por usuario
    func fetchOrdersByUser() {
        orderDAO.getOrdersByUser(profileId: profileId) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orders = orders
                print("Orders fetched successfully")
            case .failure(let error):
                self?.errorMessage = "Error loading the orders: \(error.localizedDescription)"
                print(self?.errorMessage ?? "Error ")
            }
        }
    }

    // Crear una nueva orden
    func createOrder(order: OrderModel) {
        orderDAO.createOrder(order: order) { [weak self] result in
            switch result {
            case .success:
                self?.isOrderCreated = true
                print("Order created successfully")
                self?.fetchOrdersByUser()  // Recargar órdenes después de crear una nueva
            case .failure(let error):
                self?.errorMessage = "Error creating the order: \(error.localizedDescription)"
                print(self?.errorMessage ?? "Error desconocido")
            }
        }
    }
}

