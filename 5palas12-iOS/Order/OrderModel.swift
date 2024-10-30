import Foundation
import FirebaseFirestoreSwift

struct OrderModel: Identifiable, Codable {
    @DocumentID var id: UUID? = UUID() 
    var restaurant_id: String
    var profile_id: String
    var product_ids: [String]
    var isActive: Bool
    var pickupTime: String

    enum CodingKeys: String, CodingKey {
        case id
        case restaurant_id
        case profile_id
        case product_ids
        case isActive = "isactive"
        case pickupTime = "pickuptime"
    }
}

