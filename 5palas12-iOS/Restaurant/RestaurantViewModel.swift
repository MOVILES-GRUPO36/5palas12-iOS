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
    private let restaurantSA = RestaurantSA()
    private var distanceUpdateTimer: Timer?

    
    private let imageCache = NSCache<NSString, UIImage>()

    func startDistanceUpdates() {
            distanceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.updateDistances()
            }
        }

    func stopDistanceUpdates() {
            distanceUpdateTimer?.invalidate()
            distanceUpdateTimer = nil
        }
    private let distancesQueue = DispatchQueue(label: "5palas12.distancesQueue", qos: .utility)
    
    private func updateDistances() {
        distancesQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.calculateDistances()
            
            DispatchQueue.main.async {
                self.objectWillChange.send() // Indicar que hubo cambios
                print("Restaurantes actualizados")
            }
        }
    }
    private let UIQueue = DispatchQueue(label: "5palas12.restaurantsQueue", qos: .userInteractive)
    func editRestaurant(_ updatedRestaurant: RestaurantModel) {
        distancesQueue.async { [weak self] in
            guard let self = self else { return }

            if let index = self.restaurants.firstIndex(where: { $0.restaurantID == updatedRestaurant.restaurantID }) {
                DispatchQueue.main.async {
                    self.restaurants[index] = updatedRestaurant
                }
                self.calculateDistance(for: updatedRestaurant)
                self.loadRestaurantImage(for: updatedRestaurant) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.restaurants[index].cachedImage = image
                    }
                }
            } else {
                print("No se encontró el restaurante con el ID: \(String(describing: updatedRestaurant.restaurantID))")
            }
        }
    }

    private func calculateDistance(for restaurant: RestaurantModel) {
        guard let userLocation = locationManager.lastLocation else {
            print("No se pudo obtener la ubicación del usuario")
            return
        }

        let userLatitude = userLocation.coordinate.latitude
        let userLongitude = userLocation.coordinate.longitude

        let distance = haversineDistance(
            lat1: userLatitude,
            lon1: userLongitude,
            lat2: restaurant.latitude,
            lon2: restaurant.longitude
        )

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let index = self.restaurants.firstIndex(where: { $0.restaurantID == restaurant.restaurantID }) {
                self.restaurants[index].distance = distance
            }
        }
    }
    func loadRestaurants() {
        UIQueue.async { [weak self] in
            self?.restaurantSA.getAllRestaurants { result in
                DispatchQueue.main.async {
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
        }
    }
    
    func filterRestaurants(by categories: [String]) -> [RestaurantModel] {
            return restaurants.filter { restaurant in
                !categories.isEmpty && restaurant.categories.contains { category in
                    categories.contains(category)
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
        let cacheKey = restaurant.photo 

        if let cachedImage = imageCache.object(forKey: cacheKey as NSString) {
            completion(cachedImage)
            return
        }

        guard let imageURL = URL(string: restaurant.photo) else {
            print("URL de la imagen no válida para el restaurante: \(restaurant.name)")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
            guard let self = self else { return }
            guard let data = data, let image = UIImage(data: data), error == nil else {
                print("Error al descargar imagen: \(error?.localizedDescription ?? "desconocido")")
                completion(nil)
                return
            }

            self.imageCache.setObject(image, forKey: cacheKey as NSString)
            completion(image)
        }.resume()
    }

    func clearCache() {
        imageCache.removeAllObjects()
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

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for i in 0..<self.restaurants.count {
                let restaurant = self.restaurants[i]
                let distance = self.haversineDistance(
                    lat1: userLatitude,
                    lon1: userLongitude,
                    lat2: restaurant.latitude,
                    lon2: restaurant.longitude
                )
                self.restaurants[i].distance = distance
            }
        }
    }
    
    private func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0 
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
