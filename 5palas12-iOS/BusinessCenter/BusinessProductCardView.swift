//
//  ProductCardView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

import SwiftUI

struct BusinessProductCardView: View {
    var product: ProductModel
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image at the top
            AsyncImage(url: URL(string: product.photo)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(LinearProgressViewStyle())
            }
            
            // Product details
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                
                Text(product.category)
                    .opacity(0.5)
                
                Text("Weight: \(product.weight, specifier: "%.2f") kg")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("CO2 Emissions: \(product.co2Emissions, specifier: "%.2f") kg")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding([.leading, .bottom, .trailing])
            
            // Edit button
            HStack {
                Spacer()
                Button {
                    print("Edit tapped")
                } label: {
                    Text("Edit")
                        .bold()
                        .padding(.all, 8)
                        .foregroundColor(.white)
                        .background(Color("FernGreen"))
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
