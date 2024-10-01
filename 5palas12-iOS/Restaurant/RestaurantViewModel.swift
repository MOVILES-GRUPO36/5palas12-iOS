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

    private let urlString = "https://raw.githubusercontent.com/jmontenegroc/datos/refs/heads/main/restaurantes.json"

    func loadRestaurants() {
        guard let url = URL(string: urlString) else {
            errorMessage = "URL inválida."
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Restaurant].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Error al cargar datos: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] restaurants in
                self?.restaurants = restaurants
            })
            .store(in: &cancellables)
        print(restaurants)
    }
}
