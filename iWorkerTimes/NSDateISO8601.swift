//
//  NSDateISO8601.swift
//  iWorkerTimes
//
//  Created by Shuhei Hasegawa on 2015/09/03.
//  Copyright (c) 2015年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

public extension NSDate {
    public class func ISOStringFromDate(date: NSDate?) -> String {
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        // dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        //return dateFormatter.stringFromDate(date).stringByAppendingString("Z")
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        // formatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 上記の形式の日付文字列を取得します
        return dateFormatter.stringFromDate(date!)
    }
    
    public class func dateFromISOString(string: String?) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        // dateFormatter.timeZone = NSTimeZone.localTimeZone()
        // dateFormatter.timeZone = NSTimeZone(name: "UTC")
        // dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss.SSSZ"
        
        // FullStyle
        //dateFormatter.timeStyle = .FullStyle
        //dateFormatter.dateStyle = .FullStyle
        
        return dateFormatter.dateFromString((string! as String))!
    }
}