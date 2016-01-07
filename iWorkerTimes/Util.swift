//
//  Util.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/09/16.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import Foundation

class Util {
    // 次の水曜12時を返す
    class func nextFireDate() -> NSDate {
        let date = NSDate()
        let calender = NSCalendar.currentCalendar()
        let components = calender.components(
            [.Year, .Month, .Day, .Weekday], fromDate: date)
        let weekday = components.weekday  // 1が日曜
        let hour = components.hour
        
        let fireWeekday = Week.Wednesday.rawValue
        var interval: NSTimeInterval
        if (weekday >= fireWeekday && hour >= 12) {
            interval = Double(60 * 60 * 24 * ((7 + fireWeekday) - weekday))
        } else {
            interval = Double(60 * 60 * 24 * (fireWeekday - weekday))
        }
        
        let nextDate = date.dateByAddingTimeInterval(interval)
        let fireDateComponents = calender.components(
            [.Year, .Month, .Day, .Weekday], fromDate: nextDate)
        fireDateComponents.hour = 12
        fireDateComponents.minute = 0
        fireDateComponents.second = 0
        
        return calender.dateFromComponents(fireDateComponents)!
    }
}