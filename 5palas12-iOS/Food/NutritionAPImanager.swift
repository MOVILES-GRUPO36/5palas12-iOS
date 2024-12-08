//
//  NutritionAPImanager.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import Foundation

class NutritionAPIManager: ObservableObject {
    @Published var nutritionData: [NutritionData] = []
    
    let apiKey = "+snR+xgDxCcdeJDHQEBBEw==hAw1ArEqWWiS63Ej"
    let baseURL = "https://api.api-ninjas.com/v1/nutrition"
    
    func fetchNutrition(for food: String) {
        guard let url = URL(string: "\(baseURL)?query=\(food)") else { return }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching nutrition data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received from the server.")
                return
            }
            
            do {
                // Decodificar la data
                if let decodedArray = try? JSONDecoder().decode([NutritionData].self, from: data) {
                    
                    //Multithreading
                    DispatchQueue.main.async {
                        self.nutritionData = decodedArray
                    }
                    
                }
            } catch {
                print("Error decoding nutrition data: \(error)")
            }
        }.resume()
    }
}
