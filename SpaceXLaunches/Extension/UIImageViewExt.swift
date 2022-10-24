//
//  UIImageViewExt.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL,to folderUrl: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        let manager = FileManager.default
        
        if let hashString = URL.hashedAbsolutedString(from: url) {
            let urlFolder = folderUrl.appendingPathComponent("\(hashString).jpg")
            
            if manager.fileExists(atPath: urlFolder.path), let imageFromFile = UIImage(contentsOfFile: urlFolder.path) {
                dispatchToMainThread(this: imageFromFile)
            } else {
                getImage(from: url) { [weak self] data, image in
                    self?.saveImage(data: data, to: folderUrl, withName: hashString)
                }
            }
        } else {
            getImage(from: url)
        }
    }
    
    func downloaded(from link: String, to folderUrl: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, to: folderUrl ,contentMode: mode)
    }
    
    private func getImage(from url: URL, completion: @escaping (_ data: Data, _ image: UIImage) -> Void = { _,_ in } ) {
        ImageDownloader.fetchImageData(from: url, completion: { [weak self] data, image in
            self?.dispatchToMainThread(this: image)
            completion(data, image)
        })
    }
    
    private func saveImage(data: Data, to folderUrl: URL, withName hashString: String) {
        do {
            try FileUtils.saveImage(data, to: folderUrl, named: hashString)
        } catch {
            //TODO: treat save error
            print(error)
        }
    }
    
    private func dispatchToMainThread(this image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.image = image
        }
    }
}


