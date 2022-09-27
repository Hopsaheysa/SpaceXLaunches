//
//  LaunchCellViewModel.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation
import UIKit

struct LaunchCellViewModel {
//    private var imageLoader: ImageLoaderProtocol
    
    
    var rocketName: String
    var details: String
    var upcoming: Bool
//    var dateString: String
    
    var date: Date
    
    var webcast: String?
    var article: String?
    var wikipedia: String?
    var youtubeId: String?
    
    var smallImageString: String?
    var largeImageString: String?
    
    
}
