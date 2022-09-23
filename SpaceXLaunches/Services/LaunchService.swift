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
}

class LaunchService: LaunchServiceProtocol {
    func getLaunches(completion: @escaping (Bool, Launches?, String?) -> ()) {
        HttpRequestHelper().GET(url: K.url.allLaunches,
                                params: ["": ""],
                                httpHeader: .application_json) { success, data, errorString in
            if success {
                do {
                    let model = try JSONDecoder().decode(Launches.self, from: data!)
                    completion(true, model, nil)
                } catch {
                    completion(false, nil, "Error: Data decoding failed")
                }
            } else {
                completion(false, nil, errorString)
            }
        }
    }
}
