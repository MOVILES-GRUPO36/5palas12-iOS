//
//  RestaurantViewModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation
import Combine
import SwiftUI

class RestaurantViewModel: ObservableObject {
    
    @Published var restaurants: [RestaurantModel] = []
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()
    let locationManager = LocationManager()
    private let restaurantDAO = RestaurantDAO()
    
    private let imageCache = NSCache<NSString, UIImage>()

    func loadRestaurants() {
        restaurantDAO.getAllRestaurants { [weak self] result in
            switch result {
            case .success(let restaurants):
                self?.restaurants = restaurants
                self?.calculateDistances()
                self?.cacheRestaurantsData()
                print("Restaurantes cargados y almacenados en caché")
            case .failure(let error):
                self?.errorMessage = "Error al cargar restaurantes: \(error.localizedDescription)"
                print(self?.errorMessage ?? "Error desconocido")
            }
        }
    }
    
    func getRestaurantByName(name: String) -> RestaurantModel? {
        return restaurants.first { $0.name.lowercased() == name.lowercased() }
    }

    private func cacheRestaurantsData() {
        for i in 0..<restaurants.count {
            loadRestaurantImage(for: restaurants[i]) { [weak self] image in
                DispatchQueue.main.async {
                    self?.restaurants[i].cachedImage = image
                }
            }
        }
    }

    private func loadRestaurantImage(for restaurant: RestaurantModel, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: restaurant.photo)

        if let cachedImage = imageCache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }

        guard let imageURL = URL(string: restaurant.photo) else {
            print("URL de la imagen no válida para el restaurante: \(restaurant.name)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                print("Error al descargar imagen: \(error?.localizedDescription ?? "desconocido")")
                completion(nil)
                return
            }

            self?.imageCache.setObject(image, forKey: cacheKey)
            completion(image)
        }.resume()
    }

    func clearCache() {
        imageCache.removeAllObjects() // Elimina todas las imágenes de la cache
        print("Cache de imágenes eliminado.")
    }

    func clearRestaurantsData() {
        restaurants.removeAll()
        print("Datos de restaurantes eliminados.")
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
