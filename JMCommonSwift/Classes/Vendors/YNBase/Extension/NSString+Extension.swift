//
//  NSString+Extension.swift
//  YNBase
//
//  Created by James on 2021/5/20.
//

import Foundation
import UIKit

public extension NSString {
 
    // 匹配手机号格式（1开头）
    func checkPhoneFormat() -> Bool {
        let mdnTest = NSPredicate.init(format: "SELF MATCHES %@", "^1\\d{10}")
        return mdnTest.evaluate(with: self)
    }
    
    // 匹配密码格式（6-18位的数字和字母组合）
    func checkPasswordFormat() -> Bool {
        let mdnTest = NSPredicate.init(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}")
        return mdnTest.evaluate(with: self)
    }
    
    // 时间戳转换
    func getTimeStringWithTimeStampFormat( _ format:String) -> String {
        
        let sendDate = NSDate.init(timeIntervalSince1970: self.doubleValue)
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = format
        
        let timeString = dateformatter.string(from: sendDate as Date)
        
        return timeString
    }
    
    class func getCountdownWithInterval( _ interval : TimeInterval) -> String {
        
        if interval < 60 {
            
            if interval < 10 {

                return "00:00:0\(Int(interval))"
            }
            
            return "00:00:\(Int(interval))"
        }
        
        // 5.2.59分钟前
        if interval < 60 * 60 {
            
            if Int(interval) % 60 < 10 {
                
                return "00:\(Int(interval) / 60):0\(Int(interval) % 60)"
            }
            
            return "00:\(Int(interval) / 60):\(Int(interval) % 60)"
        }
        
        // 按小时计 (72 小时内依旧显示小时)
        if interval < 60 * 60 * 24 * 3 {
            
            // 秒数小于10
            if Int(interval) % 60 < 10 {
                
                return "\(Int(interval) / (60 * 60)):\((Int(interval) % (60 * 60)) / 60):0\(Int(interval) % 60)"
            }
            
            // 分钟小于10
            if (Int(interval) % (60 * 60)) / 60 < 10 {
                
                return "\(Int(interval) / (60 * 60)):0\((Int(interval) % (60 * 60)) / 60):\(Int(interval) % 60)"
            }
            
            return "\(Int(interval) / (60 * 60)):\((Int(interval) % (60 * 60)) / 60):\(Int(interval) % 60)"
        }
        
        // 按天计
        return "\(Int(interval) / (60 * 60 * 24))天:\((Int(interval) % (60 * 60 * 24)) / (60 * 60))小时:\( ((Int(interval) % (60 * 60 * 24)) % (60 * 60)) / 60 )分钟"
    }
    func yn_weekDetail() -> String {
        let weeks = self.components(separatedBy: ",")
        
        let tempList = weeks.compactMap({ (item) -> String? in
            if item == "1" { return "周一" }
            else if item == "2" { return "周二" }
            else if item == "3" { return "周三" }
            else if item == "4" { return "周四" }
            else if item == "5" { return "周五" }
            else if item == "6" { return "周六" }
            else if item == "7" { return "周日" }
            else {return nil}
        })
        
        let result = tempList.joined(separator: "、")
        if result == "周一、周二、周三、周四、周五" {
            return "工作日"
        }else if result == "周六、周日" {
            return "双休日"
        }else if result == "周一、周二、周三、周四、周五、周六、周日" {
            return "每天"
        }else {
            return result
        }
    }
    func yn_numberToWeek() -> String {
        let weeks = self.components(separatedBy: ",")
        
        let tempList = weeks.compactMap({ (item) -> String? in
            if item == "1" { return "一" }
            else if item == "2" { return "二" }
            else if item == "3" { return "三" }
            else if item == "4" { return "四" }
            else if item == "5" { return "五" }
            else if item == "6" { return "六" }
            else if item == "7" { return "日" }
            else {return nil}
        })
        
        let reslut = tempList.joined(separator: ",")
        
        return reslut.isEmpty ? "" : "周" + reslut
    }
}
