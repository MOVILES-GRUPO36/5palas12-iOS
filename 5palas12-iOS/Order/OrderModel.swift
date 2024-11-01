import Foundation

struct OrderModel: Decodable, Identifiable, Equatable {
    var id = UUID()
    var userEmail= String
    var products : [String]
    var price: Double
    var isActive : Bool
    var pickUpTime : String
    
    enum CodingKeys : String, CodingKey{
        case userEmail
        case products
        case price
        case isActive
        case pickUpTime
    }
}

}


