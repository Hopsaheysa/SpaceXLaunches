//
//  ImageLoader.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func getImage(from urlString: String, completion: @escaping (_ success: Bool,
                                         _ results: UIImage?,
                                         _ error: String?) -> ())
}


class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func getImage(from urlString: String, completion: @escaping (Bool, UIImage?, String?) -> ()) {
        guard URL(string: urlString) != nil else { completion(false, nil, ErrorResponse.urlFail.errorDescription); return }
        
        
        //create UUID to identify the data task
        let uuid = UUID()
        
        HttpRequestHelper().GET(url: urlString,
                                params: ["":""],
                                httpHeader: .application_json) { success, data, error in
            
            //when the data task is complete it should be removed from running req. dict.
            defer {self.runningRequests.removeValue(forKey: uuid) }
            
            if success {
                if let data = data, let image = UIImage(data: data) {
                    completion(true, image, nil)
                } else {
                    completion(false, nil, ErrorResponse.imageConversionFail.errorDescription)
                }
            } else {
                completion(false, nil, error)
            }
        }
    }
    
}
