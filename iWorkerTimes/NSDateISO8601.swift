//
//  NSDateISO8601.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/09/03.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

public extension NSDate {
    
    // NSDate から 文字列
    public class func dateToString(nsDate: NSDate, nsFormat: String) -> String {
        
        let iso8601Formatter = NSDateFormatter()
        iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateString = iso8601Formatter.stringFromDate(nsDate)

        // dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        // dateFormatter.timeZone = NSTimeZone.localTimeZone()
        // dateFormatter.timeZone = NSTimeZone(name: "UTC")
        // dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        
        
        let date = iso8601Formatter.dateFromString(dateString)
        
        // FullStyle
        //dateFormatter.timeStyle = .FullStyle
        //dateFormatter.dateStyle = .FullStyle
        
        iso8601Formatter.locale = NSLocale(localeIdentifier: "ja")
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        iso8601Formatter.dateFormat = nsFormat
        //iso8601Formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        return iso8601Formatter.stringFromDate(date!)
        
    }
    
    // 文字列 から NSDate
    public class func stringToDate(string: String) -> NSDate {
        
        let iso8601Formatter = NSDateFormatter()
        iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = iso8601Formatter.dateFromString(string)

        // dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        // dateFormatter.timeZone = NSTimeZone.localTimeZone()
        // dateFormatter.timeZone = NSTimeZone(name: "UTC")
        // dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        
        //dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        
        
        let dateString = iso8601Formatter.stringFromDate(date!)
        
        // FullStyle
        //dateFormatter.timeStyle = .FullStyle
        //dateFormatter.dateStyle = .FullStyle
        
        return iso8601Formatter.dateFromString(dateString)!
        
    }
}