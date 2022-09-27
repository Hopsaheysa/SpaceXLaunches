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
    
//    fileprivate func loadData() {
//
//        let url = URL(string: "http://ws-smartit.divisionautomotriz.com/wsApiCasaTrust/api/autos")!
//
//        let task = URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//
//            guard let dataResponse = data, error == nil else {
//                print(error?.localizedDescription ?? "Response Error")
//                return
//            }
//
//            do {
//                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? NSArray
//                self.arrAutos = jsonResponse!.compactMap({ Autos($0 as? [String:String])})
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//
//            } catch let parsingError {
//                print("Error", parsingError)
//            }
//        }
//        task.resume()
//    }
}
