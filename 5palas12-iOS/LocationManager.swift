import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    @Published var nearbyRestaurants: [Restaurant] = []
    
    func fetchNearbyRestaurants() {
        // In a real app, use CoreLocation to get user's location
        // Then use an API to fetch nearby restaurants based on the location
        // For now, we'll use dummy data
        
        let dummyRestaurants = [
            Restaurant(name: "Pizza House", address: "123 Main St", distance: 0.5),
            Restaurant(name: "Sushi Place", address: "456 Ocean Ave", distance: 1.2),
            Restaurant(name: "Burger Joint", address: "789 Park Blvd", distance: 0.8)
        ]
        
        DispatchQueue.main.async {
            self.nearbyRestaurants = dummyRestaurants
        }
    }
}

