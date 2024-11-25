//
//  GeminiChatView.swift
//  5palas12-iOS
//
//  Created by Sebastian Gaona on 24/11/24.
//
import SwiftUI
import Foundation



struct GeminiChatView: View {
    @State private var chatMessages: [ChatMessage] = []  // Historial de la conversación
    @State private var userInput: String = ""  // Entrada del usuario
    @State private var isLoading: Bool = false  // Indicador de carga mientras esperamos la respuesta
    
    var body: some View {
        NavigationView {
            VStack {
                // Lista de mensajes del chat
                List(chatMessages) { message in
                    HStack {
                        if message.role == .bot {
                            GeminiMessageBubble(content: message.content)
                            Spacer()
                        } else {
                            Spacer()
                            UserMessageBubble(content: message.content)
                        }
                    }
                    .listRowSeparator(.hidden) // Sin separadores en la lista para un aspecto limpio
                }
                .listStyle(PlainListStyle())
                
                // Barra de entrada del usuario
                HStack {
                    TextField("Ask 5 palas 12...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 10)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Circle().fill(Color.gray.opacity(0.2)))
                    }
                    .disabled(userInput.isEmpty || isLoading)  // Deshabilitar el botón si no hay texto o si está cargando
                }
                .padding()
                .background(Color(UIColor.systemGroupedBackground))
            }
            .navigationTitle("Ask 5 pa las 12")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        // Agregar el mensaje del usuario al historial del chat
        let userMessage = ChatMessage(role: .user, content: trimmedInput)
        chatMessages.append(userMessage)
        
        // Limpiar el campo de entrada
        userInput = ""
        
        // Indicador de carga mientras esperamos la respuesta de la API
        isLoading = true
        
        // Definir el contexto inicial
        let initialContext = "You are a helpful assistant of 5 palas 12 app that is an app for ordering and picking food, you are here for answering questions and give the user indications for going to the diferent restaurants in bogota colombia, you should demand an initial location point and then give the user indications for arriving to the desired restaurant"
        
        // Concatenar el contexto inicial con la entrada del usuario
        let fullInput = initialContext + "\n" + trimmedInput
        
        // Realizar la solicitud a la API de Gemini
        fetchGeminiResponse(input: fullInput)
    }

    
    func fetchGeminiResponse(input: String) {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDxISDIIdOkIUT0TNRFY1Occ3rbCANZQzw") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        // Request body in JSON format
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": input]
                    ]
                ]
            ]
        ]
        
        // Convert request body to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            print("Failed to serialize JSON")
            isLoading = false
            return
        }
        
        // HTTP request configuration
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Perform the HTTP request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                isLoading = false
                return
            }
            
            if let data = data {
                do {
                    // Decode the response JSON
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let candidates = jsonResponse["candidates"] as? [[String: Any]],
                       let firstCandidate = candidates.first,
                       let content = firstCandidate["content"] as? [String: Any],
                       let parts = content["parts"] as? [[String: Any]],
                       let text = parts.first?["text"] as? String {
                        
                        // Add the bot response to the chatMessages array
                        DispatchQueue.main.async {
                            let botMessage = ChatMessage(role: .bot, content: text)
                            chatMessages.append(botMessage)
                            isLoading = false
                        }
                    } else {
                        print("Unexpected response format")
                        DispatchQueue.main.async {
                            isLoading = false
                        }
                    }
                } catch {
                    print("Error decoding response: \(error)")
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            }
        }
        
        task.resume() // Start the request
    }
}
