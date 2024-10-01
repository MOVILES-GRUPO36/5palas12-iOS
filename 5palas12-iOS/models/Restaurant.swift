import Foundation

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let distance: Double
}
