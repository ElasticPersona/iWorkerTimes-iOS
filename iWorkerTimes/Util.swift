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
        var date = NSDate()
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(
            .CalendarUnitYear |
                .CalendarUnitMonth |
                .CalendarUnitDay |
                .CalendarUnitWeekday, fromDate: date)
        var weekday = components.weekday  // 1が日曜
        var hour = components.hour
        
        var fireWeekday = Week.Wednesday.rawValue
        var interval: NSTimeInterval
        if (weekday >= fireWeekday && hour >= 12) {
            interval = Double(60 * 60 * 24 * ((7 + fireWeekday) - weekday))
        } else {
            interval = Double(60 * 60 * 24 * (fireWeekday - weekday))
        }
        
        var nextDate = date.dateByAddingTimeInterval(interval)
        var fireDateComponents = calender.components(
            .CalendarUnitYear |
                .CalendarUnitMonth |
                .CalendarUnitDay |
                .CalendarUnitWeekday, fromDate: nextDate)
        fireDateComponents.hour = 12
        fireDateComponents.minute = 0
        fireDateComponents.second = 0
        
        return calender.dateFromComponents(fireDateComponents)!
    }
}