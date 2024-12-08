//  ProfileStatsView.swift
//  5palas12-iOS
//
//  Created by santiago on 1/12/24.
//

import SwiftUI

struct ProfileStatsView: View {
    @ObservedObject var viewModel: ProfileStatsViewModel
    @State var userEmail: String
    @State private var enterTime:Date? = nil

    var body: some View {
        VStack {
            LazyVStack {
                StatCardView(
                    iconName: "banknote",
                    title: "Money invested this month saving the planet!",
                    value: String(format: "$%.2f", viewModel.stats.moneySaved),
                    footer: nil
                )

                StatCardView(
                    iconName: "leaf.fill",
                    title: "CO₂ saved this month!",
                    value: String(format: "%.2f kg", viewModel.stats.co2Saved),
                    footer: viewModel.treesPlanted
                )

                StatCardView(
                    iconName: "fork.knife",
                    title: "Amount of food saved from waste this month!",
                    value: String(format: "%.2f kg", viewModel.stats.weightSaved),
                    footer: nil
                )
            }
            .padding(.top, 20)
            .onAppear {
                print("Fetching stats for user: \(userEmail)")
                viewModel.fetchStats(for: userEmail)
                enterTime = Date()
            }
            .onDisappear {
                if let enterTime = enterTime {
                    let elapsedTime = Date().timeIntervalSince(enterTime)
                    print("User was in the view for \(elapsedTime) seconds.")
                    
                    FirebaseLogger.shared.logTimeFirebase(viewName: "ProfileStatsView", timeSpent: elapsedTime)
                }
            }
        }
    }
}

struct StatCardView: View {
    var iconName: String
    var title: String
    var value: String
    var footer: String?

    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.fernGreen)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.leading, 10)
            }
            .padding()
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.fernGreen)
                .padding(.top, 5)
            if let footerText = footer {
                Text(footerText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

