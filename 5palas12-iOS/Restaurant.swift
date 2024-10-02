import Foundation
import CoreLocation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    var distance: Double? // Optional to store the calculated distance
    let imageURL: String // Name of the local image
}
