//
//  APPDateTool.swift
//  APPSwift
//  时间处理工具
//  Created by 峰 on 2020/6/29.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class APPDateTool {
    
    ///获取当前时间@"yyyy-MM-dd HH:mm
    static func date_currentTime(timeType:String) -> String {
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = timeType
        let timeString = dateformatter.string(from: date)
        
        return timeString
    }
    
    ///获取当前时间戳 && 精度1000毫秒 1000000微妙
    static func date_currentTimeStamp(precision:Int) -> Int {
        let date = Date()
        
        let nowTime = date.timeIntervalSince1970 * TimeInterval(precision)
        
        let nowStamp:Int = Int(nowTime / 1)
        
        return nowStamp
    }
    
    ///获取当前时间戳字符串  && 精度1000毫秒 1000000微妙
    static func date_currentTimeStampString(precision:Int) -> String {
        let date = Date()
        
        let nowTime = date.timeIntervalSince1970 * TimeInterval(precision)
        
        let timeStr = String(format: "%f", nowTime)
        
        let arrayTime:[String] = timeStr.components(separatedBy: ".")
        
        return arrayTime.first ?? ""
    }
    
    ///时间戳转换时间 timeStamp:时间戳（记得转化精度为秒） timeType:转换格式(@"yyyy-MM-dd  HH:mm:ss" / yyyy年MM月dd日)
    static func date_getDateFromTimeStamp(timeStamp:Int, timeType:String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = timeType
        
        let timeString = dateformatter.string(from: date)
        
        return timeString
    }
    
    ///年月日字符转换时间时间戳 precision精度 1秒、1000毫秒、1000000微秒 (默认格式yyyy-MM-dd HH:mm:ss)
    static func date_getTimeStampFomrDate(dateStr:String, timeType:String, precision:Int) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeType//"yyyy-MM-dd HH:mm:ss"
        
        let dateTime:Date = dateFormatter.date(from: dateStr) ?? Date()
        
        let timeNum = dateTime.timeIntervalSince1970 * TimeInterval(precision)
        
        let time:Int = Int(timeNum / 1)
        
        return time
    }
    
    
}
