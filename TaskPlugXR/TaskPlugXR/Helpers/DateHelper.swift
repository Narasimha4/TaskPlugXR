//
//  DateHelper.swift
//  TaskPlugXR
//
//  Created by N, Narasimhulu on 25/12/20.
//  Copyright © 2020 Narasimha. All rights reserved.
//

import UIKit

class DateHelper {
    
    // MARK: - Get time from time stamp
    static func getTimeFromUnixTimeStamp(timeStamp: Int32) -> String {
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let formattedTime = formatter.string(from: date)
        
        return formattedTime
    }
    
}
