//
//  ProductCardView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

import SwiftUI

struct ProductCardView: View {
    var product: ProductModel
    
    var body: some View {
        VStack(alignment: .leading) {
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
            HStack {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.name)
                        .font(.headline)
                    Text("\(product.categories.joined(separator: " - "))")
                        .opacity(0.5)
                    
                }
                .padding([.leading, .bottom, .trailing])
                .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    print("pago")
                } label: {
                    Text("$"+product.price.formatted())
                        .bold()
                        .padding(.all,8)
                        .foregroundStyle(Color(.white))
                        .background(Color("FernGreen"))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
