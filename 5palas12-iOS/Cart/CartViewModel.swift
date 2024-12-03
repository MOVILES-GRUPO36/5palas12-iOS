//
//  CartViewModel.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 2/12/24.
//

import Foundation
import UIKit

class CartViewModel: ObservableObject {
    @Published var products: [ProductModel] = [] {
        didSet {
            saveCartToCache()
        }
    }
    
    private let cartKey = "CartProducts"
    private let imageCache = NSCache<NSString, UIImage>()
    
    init() {
        loadCart()
    }
    
    func addProduct(_ product: ProductModel) {
        if let cachedImage = getCachedImage(for: product.photo) {
            products.append(product)
            return
        }
        
        downloadImage(from: product.photo) { [weak self] downloadedImage in
            guard let self = self else { return }
            if let image = downloadedImage {
                self.cacheImage(image, for: product.photo)
            }
            self.products.append(product)
        }
    }
    
    // Eliminar producto del carrito
    func removeProduct(_ product: ProductModel) {
        products.removeAll(where: { $0.id == product.id })
    }
    
    // Guardar carrito en UserDefaults
    private func saveCartToCache() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(products) {
            UserDefaults.standard.set(encoded, forKey: cartKey)
        }
    }
    
    // Cargar carrito desde UserDefaults
    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: cartKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ProductModel].self, from: data) {
                self.products = decoded
            }
        }
    }
    
    // Guardar imagen en caché
    func cacheImage(_ image: UIImage, for url: String) {
        imageCache.setObject(image, forKey: url as NSString)
    }
    
    // Recuperar imagen de la caché
    func getCachedImage(for url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
    
    // Descargar imagen de una URL
    private func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let data = data, error == nil, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
