//
//  UserMessageBubble.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import SwiftUI

struct UserMessageBubble: View {
    let content: String

    var body: some View {
        Text(content)
            .padding()
            .foregroundColor(.white)
            .background(Color.fernGreen)
            .cornerRadius(15)
            .frame(maxWidth: 250, alignment: .trailing)
    }
}

struct UserMessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        UserMessageBubble(content: "This is a user message.")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
