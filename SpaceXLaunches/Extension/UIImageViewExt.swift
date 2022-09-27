//
//  UIImageViewExt.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(URLAddress: String?) {
        guard let urlString = URLAddress else { return }
        guard let url = URL(string: urlString) else { return }
        
        
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
