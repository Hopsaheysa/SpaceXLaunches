//
//  LaunchManager.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

protocol LaunchServiceProtocol {
    func getLaunches(completion: @escaping (_ success: Bool,
                                            _ results: Launches?,
                                            _ error: String?) -> ())
    
    func getImage(from urlString: String, completion: @escaping (_ success: Bool,
                                         _ results: Data?,
                                         _ error: String?) -> ())
}

class LaunchService: LaunchServiceProtocol {
    func getImage(from urlString: String, completion: @escaping (Bool, Data?, String?) -> ()) {
        HttpRequestHelper().GET(url: urlString,
                                params: ["":""],
                                httpHeader: .application_json) { success, data, error in
            if success, let data = data {
                completion(success, data, nil)
            } else {
                completion(success, nil, error)
            }
        }
    }
    

    func getLaunches(completion: @escaping (Bool, Launches?, String?) -> ()) {
        HttpRequestHelper().GET(url: K.url.allLaunches,
                                params: ["": ""],
                                httpHeader: .application_json) { success, data, error in
            if success, let data = data {
                do {
                    let model = try JSONDecoder().decode(Launches.self, from: data)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, ErrorResponse.decodingFail.errorDescription)
                }
            } else {
                completion(false, nil, error)
            }
        }
    }
}
