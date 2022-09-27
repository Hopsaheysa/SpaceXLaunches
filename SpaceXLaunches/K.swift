//
//  K.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation

struct K {
    struct url {
        static let allLaunches = "https://api.spacexdata.com/v5/launches"
    }
    
    struct segue {
        static let toDetail = "launchesToDetail"
    }
    
    struct storyboard {
        static let main = "Main"
    }
    
    struct identifier {
        static let detailVC = "detailVC"
    }
}
