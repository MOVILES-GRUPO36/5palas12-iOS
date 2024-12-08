//
//  MenuDetailView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 8/12/24.
//

import SwiftUI


struct MenuDetailView: View {
    var menu: Menu
    @StateObject private var apiManager = NutritionAPIManager()
    @State private var nutritionDetails: [String: NutritionData] = [:]
    @State private var errorMessage: String? = nil // Estado para almacenar el mensaje de error
    @State private var menus: [Menu] = [] // Lista de menús
    @StateObject private var networkMonitor = NetworkMonitor.shared // Instancia compartida del monitor de red
    private let menuStorage = MenuStorage() // Instancia del almacenamiento

    @Environment(\.presentationMode) var presentationMode // Para cerrar la vista y regresar

    var body: some View {
        VStack {
            Text(menu.name)
                .font(.largeTitle)
                .padding()
            
            if !networkMonitor.isConnected {
                // Mostrar mensaje de estado offline
                Text("You are offline")
                    .foregroundColor(.red)
                    .padding()
            }

            List(menu.products, id: \.self) { product in
                VStack(alignment: .leading) {
                    HStack {
                        Text(product)
                        Spacer()
                        Button("More Info") {
                            //Multithreading
                            DispatchQueue.main.async {
                                fetchProductNutrition(productName: product)
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(!networkMonitor.isConnected) // Deshabilitar si no hay conexión
                    }
                    
                    // Mostrar la información nutricional si está disponible
                    if let nutrition = nutritionDetails[product] {
                        VStack(alignment: .leading) {
                            Text("Nutrition for \(product):")
                                .font(.headline)
                            
                            if let fatTotal = nutrition.fatTotal {
                                Text("Total Fat: \(fatTotal, specifier: "%.2f") g")
                            }
                            if let fatSaturated = nutrition.fatSaturated {
                                Text("Saturated Fat: \(fatSaturated, specifier: "%.2f") g")
                            }
                            if let sodium = nutrition.sodium {
                                Text("Sodium: \(sodium) mg")
                            }
                            if let potassium = nutrition.potassium {
                                Text("Potassium: \(potassium) mg")
                            }
                            if let cholesterol = nutrition.cholesterol {
                                Text("Cholesterol: \(cholesterol) mg")
                            }
                            if let carbohydrates = nutrition.carbohydrates {
                                Text("Carbohydrates: \(carbohydrates, specifier: "%.2f") g")
                            }
                            if let fiber = nutrition.fiber {
                                Text("Fiber: \(fiber, specifier: "%.2f") g")
                            }
                            if let sugar = nutrition.sugar {
                                Text("Sugar: \(sugar, specifier: "%.2f") g")
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Botón de eliminar menú
            Button("Delete Menu") {
                deleteMenu()
            }
            .foregroundColor(.red)
            .padding()

            // Mostrar mensaje de error si no hay datos nutricionales
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.main.async {
                menus = menuStorage.loadMenus()
            }
        }
    }
    
    // Función para eliminar el menú
    func deleteMenu() {
        menuStorage.deleteMenu(menu: menu)
        // Actualizar la lista de menús después de eliminar
        menus = menuStorage.loadMenus()
        
        // Volver a NutritionView
        presentationMode.wrappedValue.dismiss()
    }
    
    // Función para obtener los datos nutricionales de un producto
    func fetchProductNutrition(productName: String) {
        apiManager.fetchNutrition(for: productName)
        if let firstNutritionData = apiManager.nutritionData.first {
            DispatchQueue.main.async {
                nutritionDetails[productName] = firstNutritionData
            }
        } else {
            print("No nutrition data found for \(productName)")
        }
    }
}
