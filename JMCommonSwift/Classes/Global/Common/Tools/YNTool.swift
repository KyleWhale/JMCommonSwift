//
//  YNTool.swift
//  YNCustomer
//
//  Created by james on 2021/6/3.
//

import Foundation
import UIKit
import MessageUI
import CoreLocation

public class YNTool {
    
    public static let shared = {
        return YNTool()
    }()
    private init() { }
    
    public func callPhone(_ phoneNum: String?){
        //拨打电话
        if let phone = phoneNum, phone.count > 0,
           let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("电话号码无效")
        }
        
    }
    
    
    
    
}


/// 检查用户定位是否开启
public func isUserLocationPrivacyAuthed() -> Bool {
    let localServiceStatus = CLLocationManager.authorizationStatus()
    if localServiceStatus == .authorizedAlways || localServiceStatus == .authorizedWhenInUse {
        return true
    }else {
        return false
    }
}
