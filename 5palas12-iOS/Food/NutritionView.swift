//
//  NutritionView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//


import SwiftUI


struct NutritionView: View {
    @State private var menus: [Menu] = []
    @State private var isMenuCreated: Bool = false
    @State private var showCreateMenuView: Bool = false
    @StateObject private var networkMonitor = NetworkMonitor.shared // Instancia compartida del monitor de red
    
    private let menuStorage = MenuStorage()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to your Menus")
                    .font(.largeTitle)
                    .padding()
                
                if isMenuCreated {
                    Text("Menu created successfully!")
                        .foregroundColor(.green)
                        .padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isMenuCreated = false
                            }
                        }
                }
                
                if !networkMonitor.isConnected {
                    Text("You are offline")
                        .foregroundColor(.red)
                        .padding()
                }
                
                List {
                    ForEach(menus) { menu in
                        NavigationLink(destination: MenuDetailView(menu: menu)) {
                            Text(menu.name)
                        }
                    }
                }
                
                Button("Create Menu") {
                    showCreateMenuView = true
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .disabled(!networkMonitor.isConnected) // Deshabilita el botón si no hay conexión
                
            }
            .sheet(isPresented: $showCreateMenuView) {
                CreateMenuView(isMenuCreated: $isMenuCreated, menus: $menus)
            }
            .onAppear {
                loadMenus()
            }
        }
    }
    
    func loadMenus() {
        menus = menuStorage.loadMenus()
    }
}


