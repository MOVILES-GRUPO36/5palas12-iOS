//
//  ImagePicker.swift
//  5palas12-iOS
//
//  Created by santiago on 16/10/2024.
//

import SwiftUI
import UIKit

// ImagePicker para seleccionar una imagen de la galería
struct ImagePicker: UIViewControllerRepresentable {
    
    // Vincula la imagen seleccionada
    @Binding var image: UIImage?
    
    // Función que crea el ImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // Permite la edición después de seleccionar la imagen
        return picker
    }
    
    // Función que actualiza el controlador (no necesario en este caso)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Coordinador que maneja la interacción
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    // Coordinador para manejar la selección de imágenes
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // Método que se llama cuando el usuario selecciona una imagen
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            picker.dismiss(animated: true)
        }
        
        // Método que se llama cuando el usuario cancela la selección
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
