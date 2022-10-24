//
//  UIImageViewExt.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, completionHandler: @escaping (Bool) -> Void ) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completionHandler(false)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completionHandler(true)
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit, completionHandler: @escaping (Bool) -> Void ) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode, completionHandler: completionHandler)
    }
}
