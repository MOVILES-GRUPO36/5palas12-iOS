//
//  OrderModel.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 4/11/24.
//

import Foundation

struct OrderModel: Codable, Identifiable, Equatable {
    var id = UUID()
    var orderNumber: Double 
    var userEmail: String
    var products: [String]
    var price: Double
    var isActive: Bool
    var pickUpTime: String
    var restaurantName: String

    enum CodingKeys: String, CodingKey {
        case orderNumber, userEmail, products, price, isActive, pickUpTime, restaurantName
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "orderNumber": orderNumber,
            "userEmail": userEmail,
            "products": products,
            "price": price,
            "isActive": isActive,
            "pickUpTime": pickUpTime,
            "restaurantName": restaurantName
        ]
    }
}

