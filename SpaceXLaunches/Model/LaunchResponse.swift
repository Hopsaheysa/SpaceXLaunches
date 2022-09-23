//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

typealias Launches = [Launch]

struct Launch: Codable {
    var rocketName: String?
    
    enum CodingKeys: String, CodingKey {
        case rocketName = "name"
    }
}
