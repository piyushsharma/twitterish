//
//  TimeAgo.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/31/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit
import Foundation

class TimeAgo: NSObject {

    func timeAgoSince(date: NSDate) -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .WeekOfYear, .Month, .Year, .Second]
        let components = calendar.components(unitFlags, fromDate: date, toDate: now, options: NSCalendarOptions())
        
        if components.year > 0 || components.month > 0 || components.weekOfYear > 0 || components.day >= 3 {
            let componentsOldTweet = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: date)
            return "\(componentsOldTweet.month)/\(componentsOldTweet.day)/\(componentsOldTweet.year%100)"
        }
        
        if components.day >= 2 {
            return "2d"
        }
        
        if components.day >= 1 {
            return "1d"
        }
        
        if components.hour >= 1 {
            return "\(components.hour)h"
        }
        
        if components.minute >= 1 {
            return "\(components.minute)m"
        }
                
        return "\(components.second)s"
    }

}
