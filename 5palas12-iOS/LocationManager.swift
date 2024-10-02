import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var nearbyRestaurants: [Restaurant] = []
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        checkLocationPermissions()
        locationManager.startUpdatingLocation()
    }

    // Verificar permisos de localización
    func checkLocationPermissions() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Solicitar permiso de localización
        case .denied, .restricted:
            // Manejar caso donde el permiso fue negado
            print("Permiso de localización denegado. Activa los servicios de localización.")
        case .authorizedWhenInUse, .authorizedAlways:
            // Iniciar actualización de la localización
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func fetchNearbyRestaurants() {
        // Datos ficticios de restaurantes con URLs de imágenes de Picsum
        let dummyRestaurants = [
            Restaurant(name: "Pizza House", address: "123 Main St", latitude: 37.78584, longitude: -122.406417, distance: nil, imageURL: "https://picsum.photos/200/300"),
            Restaurant(name: "Sushi Place", address: "456 Ocean Ave", latitude: 37.78583, longitude: -122.406417, distance: nil, imageURL: "https://picsum.photos/200/300"),
            Restaurant(name: "Burger Joint", address: "789 Park Blvd", latitude: 4.651446, longitude: -74.0897262, distance: nil, imageURL: "https://picsum.photos/200/300")
        ]
        
        if let userLocation = locationManager.location {
            print("Ubicación del usuario disponible: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
            
            let filteredRestaurants = dummyRestaurants.map { restaurant -> Restaurant in
                let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
                let distanceInMeters = userLocation.distance(from: restaurantLocation)
                let distanceInKilometers = distanceInMeters / 1000 // Convertir a kilómetros

                // Imprimir la distancia de cada restaurante
                print("Distancia a \(restaurant.name): \(distanceInKilometers) km")
                
                return Restaurant(
                    name: restaurant.name,
                    address: restaurant.address,
                    latitude: restaurant.latitude,
                    longitude: restaurant.longitude,
                    distance: distanceInKilometers,
                    imageURL: restaurant.imageURL // Asignar la URL de la imagen
                )
            }.filter { $0.distance ?? 0 <= 1.0 } // Filtrar restaurantes dentro de 1 km
            
            // Imprimir la cantidad de restaurantes filtrados
            print("Número de restaurantes cercanos: \(filteredRestaurants.count)")
            
            DispatchQueue.main.async {
                self.nearbyRestaurants = filteredRestaurants
            }
        } else {
            print("La localización del usuario es nil. No se pueden obtener restaurantes cercanos.")
        }
    }

    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Ubicación del usuario actualizada: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        } else {
            print("No hay localización disponible.")
        }
        
        fetchNearbyRestaurants() // Actualizar la lista de restaurantes cuando se actualiza la ubicación
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la localización: \(error)")
    }
}


