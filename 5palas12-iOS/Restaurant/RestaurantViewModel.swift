//
//  RestaurantViewModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject {
    
    @Published var restaurants: [RestaurantModel] = []
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager()
    private let restaurantDAO = RestaurantDAO()
        
    func loadRestaurants() {

        restaurantDAO.getAllRestaurants { [weak self] result in
            switch result {
            case .success(let restaurants):
                self?.restaurants = restaurants
                self?.calculateDistances()
                print("Restaurantes cargados desde Firestore correctamente")
            case .failure(let error):
                self?.errorMessage = "Error al cargar restaurantes desde Firestore: \(error.localizedDescription)"
                print(self?.errorMessage ?? "Error desconocido")
            }
        }
    }
    
    private func calculateDistances() {
        guard let userLocation = locationManager.lastLocation else {
            print("No se pudo obtener la ubicación del usuario")
            return
        }
        
        let userLatitude = userLocation.coordinate.latitude
        let userLongitude = userLocation.coordinate.longitude
        
        for i in 0..<restaurants.count {
            let restaurant = restaurants[i]
            let distance = haversineDistance(lat1: userLatitude, lon1: userLongitude, lat2: restaurant.latitude, lon2: restaurant.longitude)
            restaurants[i].distance = distance
        }
    }
    
    private func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0 // Radio de la Tierra en kilómetros
        let dLat = (lat2 - lat1) * .pi / 180.0
        let dLon = (lon2 - lon1) * .pi / 180.0
        let a = sin(dLat / 2) * sin(dLat / 2) +
                cos(lat1 * .pi / 180.0) * cos(lat2 * .pi / 180.0) *
                sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = R * c
        return distance
    }
}
