//
//  CategoriesList.swift
//  5palas12-iOS
//
//  Created by santiago on 1/12/24.
//

import Foundation

struct Category {
    let name: String
    let co2PerKg: Double // CO2 in kg per kg of product
}

let categoriesList: [Category] = [
    Category(name: "Beef", co2PerKg: 27.0),
    Category(name: "Pork", co2PerKg: 12.1),
    Category(name: "Chicken", co2PerKg: 6.9),
    Category(name: "Rice", co2PerKg: 2.7),
    Category(name: "Vegetables", co2PerKg: 0.5)
]
