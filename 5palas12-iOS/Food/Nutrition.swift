//
//  Nutrition.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import Foundation

struct NutritionData: Codable, Identifiable {
    let id = UUID()
    let name: String
    let fatTotal: Double?
    let fatSaturated: Double?
    let sodium: Int?
    let potassium: Int?
    let cholesterol: Int?
    let carbohydrates: Double?
    let fiber: Double?
    let sugar: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case fatTotal = "fat_total_g"
        case fatSaturated = "fat_saturated_g"
        case sodium = "sodium_mg"
        case potassium = "potassium_mg"
        case cholesterol = "cholesterol_mg"
        case carbohydrates = "carbohydrates_total_g"
        case fiber = "fiber_g"
        case sugar = "sugar_g"
    }
}
