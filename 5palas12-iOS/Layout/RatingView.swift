//
//  RatingView.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 20/10/24.
//

import SwiftUI

struct RatingView: View {
    @State var rating: Double = 0
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                if index < Int(rating) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color("FernGreen"))
                        .cornerRadius(4)
                } else if index < Int(rating + 0.5) {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color("FernGreen"))
                        .cornerRadius(4)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color("FernGreen"))
                        .cornerRadius(4)
                }
            }
        }

    }
}

#Preview {
    RatingView()
}
