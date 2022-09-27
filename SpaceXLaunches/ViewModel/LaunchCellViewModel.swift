//
//  LaunchCellViewModel.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation
import UIKit

struct LaunchCellViewModel {
    
    var rocketName: String
    var details: String
    var upcoming: Bool
    var success: Bool
    var date: Date
    
    var article: String?
    var wikipedia: String?
    var youtubeId: String?
    
    var smallImageString: String?
    var largeImageString: String?
}
