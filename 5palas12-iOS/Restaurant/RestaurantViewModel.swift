//
//  RestaurantViewModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var errorMessage: String? = nil
    private var cancellables = Set<AnyCancellable>()

    private let urlString = "https://raw.githubusercontent.com/jmontenegroc/datos/refs/heads/main/restaurants.json"

    func loadRestaurants() {
        guard let url = URL(string: urlString) else {
            errorMessage = "URL inválida."
            print(errorMessage ?? "Error desconocido")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("Código de estado HTTP: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Datos cargados correctamente")
                case .failure(let error):
                    self.errorMessage = "Error al cargar datos: \(error.localizedDescription)"
                    print(self.errorMessage ?? "Error desconocido")
                }
            }, receiveValue: { [weak self] restaurants in
                self?.restaurants = restaurants
            })
            .store(in: &cancellables)
    }
}

