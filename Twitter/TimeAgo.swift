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
        let unitFlags: NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfYear, .Month, .Year]
        let components = calendar.components(unitFlags, fromDate: date, toDate: now, options: [])
        
        if components.day >= 3 {
            return "\(components.month)/\(components.day)/\(components.year)"
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
