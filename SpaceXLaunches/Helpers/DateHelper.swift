//
//  DateHelper.swift
//  SpaceXLaunches
//
//  Created by Marek Stransky on 26.09.2022.
//

import Foundation

struct DateHelper {

    public static func stringToDate(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") // set locale
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00") as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatDate = dateFormatter.date(from:date) ?? Date(timeIntervalSince1970: 0)
        return dateFormatDate
    }
    
}
