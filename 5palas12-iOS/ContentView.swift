//
//  ContentView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 30/09/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RestaurantViewModel()
    
    var body: some View {
            VStack {
                MapView(restaurantsVM: viewModel)
            }
            .onAppear {
                viewModel.loadRestaurants()             }
        }
    
}
