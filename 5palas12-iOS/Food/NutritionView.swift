//
//  NutritionView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import SwiftUI


struct NutritionView: View {
    @StateObject private var apiManager = NutritionAPIManager()
    @State private var foodInput: String = ""

    var body: some View {
        VStack {
            // TextField for user input
            TextField("Enter food name", text: $foodInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            // Button to fetch nutrition data
            Button("Fetch Nutrition Info") {
                apiManager.fetchNutrition(for: foodInput)
            }
            .padding()
            .buttonStyle(.borderedProminent)

            // List to display the fetched data
            List(apiManager.nutritionData) { item in
                VStack(alignment: .leading) {
                    Text(item.name.capitalized)
                        .font(.headline)

                    // Safely unwrap and display the data with default values
                    Text("Total Fat: \(item.fatTotal ?? 0.0, specifier: "%.2f") g")
                    Text("Saturated Fat: \(item.fatSaturated ?? 0.0, specifier: "%.2f") g")
                    Text("Sodium: \(item.sodium ?? 0) mg")
                    Text("Potassium: \(item.potassium ?? 0) mg")
                    Text("Cholesterol: \(item.cholesterol ?? 0) mg")
                    Text("Carbohydrates: \(item.carbohydrates ?? 0.0, specifier: "%.2f") g")
                    Text("Fiber: \(item.fiber ?? 0.0, specifier: "%.2f") g")
                    Text("Sugar: \(item.sugar ?? 0.0, specifier: "%.2f") g")
                }
                .padding()
            }
        }
        .padding()
    }
}
