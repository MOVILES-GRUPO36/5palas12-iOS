//
//  RestaurantDetailView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 1/10/24.
//
import Foundation
import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        GeometryReader{geometry in
            VStack {
                AsyncImage(url: URL(string: restaurant.photo) )
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
                
                VStack(alignment: .leading)
                {
                    Text(restaurant.name)
                        .font(.headline)
                    
                    Text("\(restaurant.categories.joined(separator: " - "))")
                        .opacity(0.5)
                    
                    Text("Rating: \(restaurant.rating)")
                }.frame(width: geometry.size.width)
                    .padding(.vertical, 30)
                    .padding(.horizontal, 0)
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
        }
    }
}
