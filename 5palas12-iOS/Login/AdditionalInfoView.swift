//
//  AdditionalInfoView.swift
//  5palas12-iOS
//
//  Created by santiago on 16/10/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseAnalytics

struct AdditionalInfoView: View {
    @State private var selectedImage: UIImage?
    @State private var birthDate = Date()
    @State private var showImagePicker = false
    @State private var isLoading = false
    @State private var imageURL: URL?

    var body: some View {
        VStack {
            Text("We need you to provide us with additional information")
                .font(.largeTitle)
            
            Button(action: {
                showImagePicker = true
            }) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            
            if isLoading {
                            ProgressView("Uploading Image...")
                        }
            
            DatePicker("Select Birthdate", selection: $birthDate, displayedComponents: .date)
                .padding(40)
            
            Spacer()
            
            Button("Save User Info") {
                            guard let image = selectedImage else { return }
                            isLoading = true
                            uploadImageToGCP(image: image) { url in
                                isLoading = false
                                if let url = url {
                                    imageURL = url
                                    print("Image uploaded successfully: \(url.absoluteString)")
                                    saveUserDataToPostgres(imageURL: url.absoluteString)
                                } else {
                                    print("Failed to upload image")
                                }
                            }
                        }
                        .disabled(isLoading || selectedImage == nil)
                
                
        }
        
        }
    }

func uploadImageToGCP(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        // Tu URL del bucket de GCP
        let bucketURL = "https://storage.googleapis.com/YOUR_BUCKET_NAME"
        let fileName = UUID().uuidString + ".jpg"
        let url = URL(string: "\(bucketURL)/\(fileName)")!

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")

        // Reemplazar por tu token de acceso si estás usando autenticación
        // request.addValue("Bearer YOUR_ACCESS_TOKEN", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else {
                completion(url)
            }
        }
        task.resume()
    }

    // Función para guardar los datos del usuario en PostgreSQL
    func saveUserDataToPostgres(imageURL: String) {
        // Información del usuario
        let userName = "John Doe" // Reemplaza con los datos del usuario
        let birthDate = "1990-01-01" // Reemplaza con la fecha seleccionada por el usuario

        // Aquí deberías tener la conexión con tu base de datos de PostgreSQL
        let url = URL(string: "https://your-api-url.com/saveUser")! // Cambia esto a tu API que maneje la base de datos
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Datos del usuario que quieres guardar
        let body: [String: Any] = [
            "name": userName,
            "birthDate": birthDate,
            "profileImageURL": imageURL
        ]

        // Serializamos el cuerpo a JSON
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        // Hacemos la solicitud HTTP
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error saving user data: \(error)")
                return
            }

            print("User data saved successfully!")
        }
        task.resume()
    }
}


#Preview {
    AdditionalInfoView()
}
