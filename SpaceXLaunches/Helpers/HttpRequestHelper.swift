//
//  HttpRequestHelper.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

enum HTTPHeaderFields {
    case application_json
    case application_x_www_form_urlencoded
    case none
}

class HttpRequestHelper {
    func GET(url: String, params: [String: String], httpHeader: HTTPHeaderFields, complete: @escaping (Bool, Data?, String?) -> ()) {        
        guard var components = URLComponents(string: url) else {
            //Error: cannot create URLCompontents
            return
        }
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }

        guard let url = components.url else {
            // Error: cannot create URL
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        switch httpHeader {
        case .application_json:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .application_x_www_form_urlencoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .none: break
        }

        
        // .ephemeral prevent JSON from caching (They'll store in Ram and nothing on Disk)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                complete(false, nil, error!.localizedDescription)
                return
            }
            guard let data = data else {
                complete(false, nil, ErrorResponse.noData.errorDescription)
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                complete(false, nil, ErrorResponse.requestFail.errorDescription)
                return
            }
            complete(true, data, nil)
        }.resume()
    }
}
