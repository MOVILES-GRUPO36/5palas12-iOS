import Foundation

struct OrderModel: Identifiable {
    var id = UUID()
    var order_id: String
    var restaurant_id: String
    var profile_id: String
    var product_ids: [UUID]
    var total_price: Double
    var estimated_time: String
}


