//
//  ProfileStatsView.swift
//  5palas12-iOS
//
//  Created by santiago on 1/12/24.
//

import SwiftUI

struct ProfileStatsView: View {
    var moneySaved: Double
    var co2Saved: Double
    
    var body: some View {
        VStack {
            // Money Invested Card
            VStack {
                HStack {
                    Image(systemName: "banknote") // Bill icon
                        .resizable()
                        .frame(width: 30, height: 20)
                        .foregroundColor(.green) // Green color for eco-friendliness
                    
                    Text("Money invested this month saving the planet!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                }
                .padding()
                
                // Display the amount of money saved
                Text("$\(moneySaved, specifier: "%.2f")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal)

            // CO2 Saved Card
            VStack {
                HStack {
                    Image(systemName: "leaf.fill") // Leaf icon
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green) // Green color for eco-friendliness
                    
                    Text("CO2 saved this month!")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                }
                .padding()
                
                // Display the amount of CO2 saved
                Text("\(co2Saved, specifier: "%.2f") kg")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
        .padding(.top, 20)
    }
}

