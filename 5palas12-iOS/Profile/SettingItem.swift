//
//  SettingItem.swift
//  5palas12-iOS
//
//  Created by santiago on 19/10/2024.
//

import Foundation

struct SettingItem: Identifiable {
    let id = UUID() // Unique identifier
    let title: String
    let icon: String? // Optional icon name for SF Symbols
    let type: SettingType // Type of the setting item
}

enum SettingType {
    case toggle(Bool) // Toggle switch with a boolean value
    case navigation // Navigation to another view
    case plain // Simple text item
}
