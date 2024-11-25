//
//  ChatView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//

import SwiftUI

struct ChatView: View {
    @Binding var chatMessages: [ChatMessage]
    @Binding var userInput: String
    var onSend: () -> Void

    var body: some View {
        VStack {
            List(chatMessages) { message in
                HStack {
                    if message.role == .bot {
                        Spacer()
                        Text(message.content)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                            .frame(maxWidth: 250, alignment: .leading)
                    } else {
                        Text(message.content)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .frame(maxWidth: 250, alignment: .trailing)
                        Spacer()
                    }
                }
            }

            HStack {
                TextField("Type a message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: onSend) {
                    Text("Send")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
