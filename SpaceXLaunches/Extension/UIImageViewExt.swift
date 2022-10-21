//
//  UIImageViewExt.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import Foundation
import UIKit

import CryptoKit


extension UIImageView {
    func downloaded(from url: URL,to folderUrl: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        let manager = FileManager.default
        
        if let urlData = url.absoluteString.data(using: .utf8) {
            let hash = Insecure.MD5.hash(data: urlData)
            // 1. created hash name
            let hashString = hash.map { String(format: "%02hhx", $0) }.joined()
            let urlFolder = folderUrl.appendingPathComponent("\(hashString).jpg")

            // 2. check if the file already exists
            if manager.fileExists(atPath: urlFolder.path) {
                let imageFromFile = UIImage(contentsOfFile: urlFolder.path)
                
                DispatchQueue.main.async { [weak self] in
                    // 3. use saved image
                    self?.image = imageFromFile
                }
                
                // 4. continue with downloading
            } else {
                getImage(from: url, to: folderUrl, with: hashString)
            }
            // if url is not successfully converted to data
        } else {
            getImage(from: url)
        }
    }
    
    func downloaded(from link: String, to folderUrl: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, to: folderUrl ,contentMode: mode)
    }
    
    
    func getImage(from url: URL, to folderUrl: URL, with hashString: String) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {  return  }
            
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            
            // 5. check if the folder exists and save to temporary folder
            if FileManager.default.fileExists(atPath: folderUrl.path) {
                do {
                    try data.write(to: folderUrl.appendingPathComponent("\(hashString).jpg"))
                } catch {
                    // should be treated somehow? mainly for large images
                    print(error)
                    UserDefaults.standard.removeObject(forKey: K.defaultsKey.temporaryFolderUrl)
                }
            } else {
                //delete UserDefault record so in LaunchVC viewWillAppear new one is created
                UserDefaults.standard.removeObject(forKey: K.defaultsKey.temporaryFolderUrl)
            }
        }.resume()
    }
    
    func getImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {  return  }
            
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}


