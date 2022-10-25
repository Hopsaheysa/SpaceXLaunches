//
//  ImageDownloader.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 24.10.2022.
//

import Foundation
import UIKit

class ImageDownloader {
    static func fetchImageData(from url: URL, completion: @escaping (_ data: Data, _ image: UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            completion(data, image)
        }.resume()
    }
}
