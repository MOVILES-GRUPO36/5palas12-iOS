//
//  MenuStorage.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 8/12/24.
//

import Foundation

// Local storage
class MenuStorage {
    private let menusKey = "savedMenusKey"
    
    // Guardar una lista de menús en UserDefaults
    func saveMenus(_ menus: [Menu]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(menus) {
            UserDefaults.standard.set(encoded, forKey: menusKey)
        }
    }
    
    // Cargar la lista de menús desde UserDefaults
    func loadMenus() -> [Menu] {
        if let savedMenusData = UserDefaults.standard.data(forKey: menusKey),
           let decodedMenus = try? JSONDecoder().decode([Menu].self, from: savedMenusData) {
            return decodedMenus
        }
        return []
    }
    
    // Eliminar un solo menú de la lista guardada en UserDefaults
    func deleteMenu(menu: Menu) {
        var menus = loadMenus()  // Cargar los menús actuales
        
        // Filtrar el menú que se quiere eliminar
        menus.removeAll { $0.id == menu.id }
        
        // Guardar la lista actualizada sin el menú eliminado
        saveMenus(menus)
    }
}
