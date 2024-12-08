//
//  ImageManager.swift
//  5palas12-iOS
//
//  Created by Juan Jose Montenegro Chaves on 3/12/24.
//

import Foundation
import SwiftUI
import CommonCrypto
import CryptoKit

class ImageManager {
    static let shared = ImageManager()
    private let fileManager = FileManager.default
    private let directoryURL: URL

    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        directoryURL = paths[0].appendingPathComponent("CategoryImages")
        
        if !fileManager.fileExists(atPath: directoryURL.path) {
            try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
    }

    func getImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        let fileName = hashedFileName(for: url)
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            DispatchQueue.global(qos: .utility).async {
                let image = UIImage(contentsOfFile: fileURL.path)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        } else {
            downloadImage(from: url, to: fileURL, completion: completion)
        }
    }

    private func downloadImage(from urlString: String, to fileURL: URL, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global(qos: .utility).async {
            let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                do {
                    try data.write(to: fileURL)
                } catch {
                    print("Error saving file: \(error)")
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }

    private func hashedFileName(for url: String) -> String {
        let hash = Insecure.MD5.hash(data: url.data(using: .utf8)!)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
