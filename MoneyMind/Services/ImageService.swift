//
//  ImageService.swift
//  MoneyMind
//
//  Created by Павел on 31.05.2025.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
    func downloadImage(by stringURL: String?, completion: @escaping (UIImage?) -> Void)
}

final class ImageService: ImageServiceProtocol {
    private let cache: NSCache<NSURL, NSData> = NSCache()
    private let imageSession: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    func downloadImage(by stringURL: String?, completion: @escaping (UIImage?) -> Void) {
        guard let stringURL = stringURL else {
            return completion(nil)
        }

        let completedURLString: String
        if stringURL.starts(with: "http") {
            completedURLString = stringURL
        } else {
            completedURLString = "https://\(stringURL)"
        }

        guard let url = URL(string: completedURLString) else {
            print("downloadImage: Invalid URL : \(completedURLString)")
            return completion(nil)
        }

        if let imageData = cache.object(forKey: url as NSURL) {
            completion(UIImage(data: imageData as Data))
            return
        }

        let task = imageSession.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("downloadImage: Network error for URL: \(url)")
                completion(nil)
                return
            }

            self?.cache.setObject(data as NSData, forKey: url as NSURL)
            completion(UIImage(data: data))
        }
        task.resume()
    }

}
