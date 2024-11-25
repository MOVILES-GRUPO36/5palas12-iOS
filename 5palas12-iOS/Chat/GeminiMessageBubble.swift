//
//  GeminiMessageBubble.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import SwiftUI

struct GeminiMessageBubble: View {
    let content: String

    var body: some View {
        Text(content)
            .padding()
            .foregroundColor(.black)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(15)
            .frame(maxWidth: 250, alignment: .leading)
    }
}

struct GeminiMessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        GeminiMessageBubble(content: "This is 5 pa las 12 message.")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
