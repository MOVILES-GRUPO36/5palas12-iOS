//
//  Menu.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 8/12/24.
//

import Foundation

// Modelo para un producto
struct Menu: Codable, Identifiable {
    var id = UUID()
    var name: String
    var products: [String]
}
