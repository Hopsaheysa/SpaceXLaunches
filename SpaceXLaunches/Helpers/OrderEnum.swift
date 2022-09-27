//
//  OrderEnum.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 27.09.2022.
//

import Foundation

enum Order: String {
    case ascending = "Ascending"
    case descending = "Descending"
    case other = "other"
    
    init(fromRawValue: String?) {
        self = Order(rawValue: fromRawValue ?? "other") ?? .other
    }
}
