//
//  ImageDownloader.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 24.10.2022.
//

import Foundation
import UIKit

class ImageDownloader {
    static let shared = ImageDownloader()
    
    func downloadImage(from link: String,to folderUrl: URL?, completionHandler: @escaping (Bool, UIImage?) -> Void ) {
        guard let url = URL(string: link) else { return }
        downloadImage(from: url, to: folderUrl, completionHandler: completionHandler)
    }
    
    func downloadImage(from url: URL, to folderUrl: URL?, completionHandler: @escaping (Bool, UIImage?) -> Void ) {
        let manager = FileManager.default
        
        if let folderUrl = folderUrl, let hashString = url.hashedAbsolutedString(from: url) {
            let urlFolder = folderUrl.appendingPathComponent("\(hashString).jpg")
            if manager.fileExists(atPath: urlFolder.path), let imageFromFile = UIImage(contentsOfFile: urlFolder.path) {
                completionHandler(true, imageFromFile)
            } else {
                getImage(from: url) { [weak self] data, image, success in
                    if success, let data = data {
                        self?.saveImage(data: data, to: folderUrl, withName: hashString)
                    }
                    DispatchQueue.main.async {
                        completionHandler(success, image)
                    }
                }
            }
        } else {
            getImage(from: url) { data, image, success in
                DispatchQueue.main.async {
                    completionHandler(success, image)
                }
            }
        }
    }
    
    private func fetchImageData(from url: URL, completion: @escaping (_ data: Data?, _ image: UIImage?, _ success: Bool) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion(nil, nil, false)
                return }
            completion(data, image, true)
        }.resume()
    }

    private func getImage(from url: URL, completion: @escaping (_ data: Data?, _ image: UIImage?, _ success: Bool) -> Void ) {
        fetchImageData(from: url, completion: { data, image, success in
            if success {
                completion(data!, image!, true)
            } else {
                completion(nil, nil, false)
            }
        })
    }
    
    private func saveImage(data: Data, to folderUrl: URL, withName hashString: String) {
        do {
            try FileUtils.saveImage(data, to: folderUrl, named: hashString)
        } catch {
            print(error)
        }
    }
}
