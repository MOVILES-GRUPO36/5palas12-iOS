//
//  CreateMenuView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 8/12/24.
//

import SwiftUI


struct CreateMenuView: View {
    @State private var menuName: String = ""
    @State private var selectedProducts: [String] = []
    @State private var productNames: [String] = []
    @State private var nutritionInfo: NutritionData? = nil
    @StateObject private var apiManager = NutritionAPIManager()
    @Binding var isMenuCreated: Bool
    @Binding var menus: [Menu]
    private let productDAO = ProductDAO()
    
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    
    private let menuStorage = MenuStorage()
    
    var body: some View {
        VStack {
            Text("Create New Menu")
                .font(.largeTitle)
                .padding()
            
            // Menu Name Field
            TextField("Enter Menu Name", text: $menuName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Product List
            List(productNames, id: \.self) { name in
                HStack {
                    Text(name)
                    Spacer()
                    
                    // Show "Added" indicator for selected products
                    if selectedProducts.contains(name) {
                        Text("Added")
                            .foregroundColor(.green)
                            .font(.caption)
                            .padding(.trailing)
                    } else {
                        Button("Add") {
                            addProductToMenu(product: name)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button("More Info") {
                        //Multithreading
                        DispatchQueue.main.async {
                            fetchProductNutrition(productName: name)
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // Save Menu Button
            Button("Save Menu") {
                saveMenu()
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .disabled(menuName.isEmpty || selectedProducts.isEmpty) // Disable button if name or products are missing
            
            // Nutrition Info Section
            if let nutritionInfo = nutritionInfo {
                VStack(alignment: .leading) {
                    Text("Nutrition Information for \(nutritionInfo.name)")
                        .font(.headline)
                    
                    if let fatTotal = nutritionInfo.fatTotal {
                        Text("Total Fat: \(fatTotal, specifier: "%.2f") g")
                    }
                    if let fatSaturated = nutritionInfo.fatSaturated {
                        Text("Saturated Fat: \(fatSaturated, specifier: "%.2f") g")
                    }
                    if let sodium = nutritionInfo.sodium {
                        Text("Sodium: \(sodium) mg")
                    }
                    if let potassium = nutritionInfo.potassium {
                        Text("Potassium: \(potassium) mg")
                    }
                    if let cholesterol = nutritionInfo.cholesterol {
                        Text("Cholesterol: \(cholesterol) mg")
                    }
                    if let carbohydrates = nutritionInfo.carbohydrates {
                        Text("Carbohydrates: \(carbohydrates, specifier: "%.2f") g")
                    }
                    if let fiber = nutritionInfo.fiber {
                        Text("Fiber: \(fiber, specifier: "%.2f") g")
                    }
                    if let sugar = nutritionInfo.sugar {
                        Text("Sugar: \(sugar, specifier: "%.2f") g")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            //Multithreading
            DispatchQueue.main.async {
            fetchProductNames()
            }
        }
    }
    
    // MARK: - Functions
    
    func addProductToMenu(product: String) {
        if !selectedProducts.contains(product) {
            selectedProducts.append(product)
        }
    }
    
    func fetchProductNames() {
        
            productDAO.getAllProductsName { result in
                switch result {
                case .success(let products):
                    self.productNames = products
                case .failure(let error):
                    print("Error fetching product names: \(error)")
                }
            }
        }
      
    
    func fetchProductNutrition(productName: String) {
        apiManager.fetchNutrition(for: productName)
        if let firstNutritionData = apiManager.nutritionData.first {
            nutritionInfo = firstNutritionData
        } else {
            print("No nutrition data found for \(productName)")
        }
    }
    
    func saveMenu() {
        if !menuName.isEmpty && !selectedProducts.isEmpty {
            let newMenu = Menu(name: menuName, products: selectedProducts)
            menus.append(newMenu)
            menuStorage.saveMenus(menus)
            isMenuCreated = true
            
            // Dismiss the view to go back to NutritionView
            presentationMode.wrappedValue.dismiss()
        }
    }
}
