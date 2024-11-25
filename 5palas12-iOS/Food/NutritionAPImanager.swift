//
//  NutritionAPImanager.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import Foundation

class NutritionAPIManager: ObservableObject {
    @Published var nutritionData: [Nutrition] = []
    
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
                // Try decoding the data as an array first
                if let decodedArray = try? JSONDecoder().decode([Nutrition].self, from: data) {
                    DispatchQueue.main.async {
                        self.nutritionData = decodedArray
                    }
                } else {
                    // If decoding as an array fails, try decoding as a dictionary
                    if let decodedDict = try? JSONDecoder().decode([String: String].self, from: data),
                       let errorMessage = decodedDict["error"] {
                        print("API Error: \(errorMessage)")
                    } else {
                        print("Unknown response format.")
                    }
                }
            } catch {
                print("Error decoding nutrition data: \(error)")
            }
        }.resume()
    }
}
