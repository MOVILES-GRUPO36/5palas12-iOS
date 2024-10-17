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
    @State var name: String
    @State var surname: String
    @State var email: String
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
                
                // Show loading spinner while the upload is in progress
                isLoading = true
                
                // Use the GCS upload function with completion handler
                uploadImageToGCS(image: image) { url in
                    // Ensure UI updates happen on the main thread
                    DispatchQueue.main.async {
                        // Hide loading spinner after upload is complete
                        isLoading = false
                        
                        if let url = url {
                            // Update the UI with the image URL
                            imageURL = url
                            print("Image uploaded successfully: \(url.absoluteString)")
                            
                            // Save user data to Postgres with the image URL
                            saveUserDataToPostgres(imageURL: url.absoluteString)
                        } else {
                            // Handle the error case
                            print("Failed to upload image")
                        }
                    }
                }
            }
            .disabled(isLoading || selectedImage == nil)

                
                
        }
        
        }
    }

    func uploadImageToGCS(image: UIImage, completion: @escaping (URL?) -> Void) {
        // Convert the image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: Could not convert image to data.")
            completion(nil)  // Signal an error by returning nil
            return
        }

        // 1. Get the signed URL from your backend
        let backendURL = URL(string: "https://your-backend-server.com/getSignedUrl")!  // Your backend endpoint for getting the signed URL
        var request = URLRequest(url: backendURL)
        request.httpMethod = "POST"
        
        // 2. Prepare the body with userId and objectName
        let userId = Auth.auth().currentUser?.uid ?? "unknown-user"
        let objectName = UUID().uuidString + ".jpg"  // Generate a unique file name
        
        let body = ["userId": userId, "objectName": objectName]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. Make the request to get the signed URL from the backend
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to get signed URL: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)  // Signal an error by returning nil
                return
            }

            // 4. Parse the signed URL from the backend response
            if let signedUrlString = String(data: data, encoding: .utf8),
               let signedUrl = URL(string: signedUrlString) {

                // 5. Upload the image to GCS using the signed URL
                var uploadRequest = URLRequest(url: signedUrl)
                uploadRequest.httpMethod = "PUT"
                uploadRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
                uploadRequest.httpBody = imageData

                let uploadTask = URLSession.shared.dataTask(with: uploadRequest) { data, response, error in
                    if let error = error {
                        print("Upload error: \(error.localizedDescription)")
                        completion(nil)  // Signal an error by returning nil
                        return
                    }
                    
                    // 6. If upload is successful, return the signed URL (the file's public URL)
                    print("File uploaded successfully!")
                    completion(signedUrl)  // Return the signed URL via completion
                }
                uploadTask.resume()
            } else {
                print("Failed to parse signed URL")
                completion(nil)  // Signal an error by returning nil
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




