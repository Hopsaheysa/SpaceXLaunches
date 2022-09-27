//
//  Launch.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 23.09.2022.
//

import Foundation
import UIKit

typealias Launches = [Launch]


struct Launch: Codable {
    var rocketName: String?
    var details: String?
    var upcoming: Bool?
    var dateString: String?
    
    var date: Date?
    
    var webcast: String?
    var article: String?
    var wikipedia: String?
    var youtubeId: String?
    
    var smallImage: String?
    var largeImage: String?
    
    
    enum LaunchKeys: String, CodingKey {
        case rocketName = "name"
        case links = "links"
        case details
        case upcoming
        case dateString = "date_utc"
    }
    
    enum LinksKeys: String, CodingKey {
        case images = "patch"
        case webcast, article, wikipedia
        case youtubeId = "youtube_id"
    }
    
    enum ImageKeys: String, CodingKey {
        case smallImage = "small"
        case largeImage = "large"
    }
}

extension Launch {
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: LaunchKeys.self)
        rocketName = try? container.decode(String.self, forKey: .rocketName)
        
        
        let details = try? container.decode(String.self, forKey: .details)
        
        self.upcoming = try? container.decode(Bool.self, forKey: .upcoming)
        
        if let dateString = try? container.decode(String.self, forKey: .dateString) {
            self.dateString = dateString
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            if let dateConverted = formatter.date(from: dateString) {
                date = dateConverted
            } else {
                date = Date.distantPast
                throw DecodingError.dataCorruptedError(forKey: .dateString,
                                                       in: container,
                                                       debugDescription: ErrorResponse.dateFail.localizedDescription)
            }
        }
        
        if let linksContainer = try? container.nestedContainer(keyedBy: LinksKeys.self, forKey: .links) {
            self.webcast = try? linksContainer.decode(String.self, forKey: .webcast)
            self.article = try? linksContainer.decode(String.self, forKey: .article)
            self.wikipedia = try? linksContainer.decode(String.self, forKey: .wikipedia)
            self.youtubeId = try? linksContainer.decode(String.self, forKey: .youtubeId)
            
            if let imagesContainer = try? linksContainer.nestedContainer(keyedBy: ImageKeys.self, forKey: .images) {
                self.smallImage = try? imagesContainer.decode(String.self, forKey: .smallImage)
                self.largeImage = try? imagesContainer.decode(String.self, forKey: .largeImage)
            }
        }
    }
}


//extension Links {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: LinksKeys.self)
//        webcast = try container.decode(String.self, forKey: .webcast)
//        article = try container.decode(String.self, forKey: .article)
//        wikipedia = try container.decode(String.self, forKey: .wikipedia)
//        youtubeId = try container.decode(String.self, forKey: .youtubeId)
//    }
//}

//struct Links: Codable {
//    var webcast: String?
//    var images: ImageStruct?
//    var article: String?
//    var wikipedia: String?
//    var youtubeId: String?
//
//    enum LinksKeys: String, CodingKey {
//        case images = "patch"
//        case webcast, article, wikipedia
//        case youtubeId = "youtube_id"
//    }
//}
//
//struct ImageStruct: Codable {
//    var smallImage: String?
//    var largeImage: String?
//
//    enum ImageKeys: String, CodingKey {
//        case smallImage = "small"
//        case largeImage = "large"
//    }
//}
