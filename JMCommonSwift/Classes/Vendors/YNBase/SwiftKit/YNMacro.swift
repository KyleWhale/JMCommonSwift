//
//  YNMacro.swift
//  YNUtilitySwift
//
//  Created by james on 2018/12/20.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

//MARK: 常用类型定义

/// 默认字典类型
public typealias YNDefaultDic = [String: Any]
/// 不带参数函数
public typealias YNEmptyParamsFunc = () -> Void

///MARK: 设备宽高
public let YN_SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let YN_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let YN_SCREEN_BOUNDS = UIScreen.main.bounds
public let YN_SCREENMIN = min(YN_SCREEN_WIDTH, YN_SCREEN_HEIGHT)
public let YN_SCREENMAX = max(YN_SCREEN_WIDTH, YN_SCREEN_HEIGHT)
public let YN_SCREEN_SCALE = UIScreen.main.scale

/*设备型号*/
public let YN_IPHONE = (UIDevice.current.userInterfaceIdiom == .phone)
public let YN_IPHONE_4_OR_LESS = (YN_IPHONE && YN_SCREENMAX < 568.0)
public let YN_IPHONE_5 = (YN_IPHONE && YN_SCREENMAX == 568.0)
public let YN_IPHONE_6 = (YN_IPHONE && YN_SCREENMAX == 667.0)//4.7寸
public let YN_IPHONE_6_OR_LESS = (YN_IPHONE && YN_SCREENMAX <= 667.0)//4.7寸
public let YN_IPHONE_6P = (YN_IPHONE && YN_SCREENMAX == 736.0)//5.5寸
public let YN_IPHONE_X = (YN_IPHONE && YN_SCREENMAX == 812.0) //5.8寸
public let YN_IPHONE_XROrMax = (YN_IPHONE && YN_SCREENMAX == 896.0) //6.1、6.5寸
public let YN_IPHONE_12 = (YN_IPHONE && YN_SCREENMAX == 844.0) //12、12pro
public let YN_IPHONE_12_MAX = (YN_IPHONE && YN_SCREENMAX == 926.0) // 12 pro max
public let YN_IPHONE_12_MINI = (YN_IPHONE && YN_SCREENMAX == 780.0) // 12 mini
public let YN_IPHONE_FRINGE = (YN_IPHONE_X || YN_IPHONE_XROrMax || YN_IPHONE_12 || YN_IPHONE_12_MAX || YN_IPHONE_12_MINI) //iphone X刘海屏系列

//版本
public let YN_IS_IOS_10 = (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0

/// 判断设备
public let YN_IsIphoneX = UIScreen.main.bounds.size.height >= 812

/// 顶部间隙 - 用来区分 是否IPHONE X
public let YN_DEVICE_TOP = (UIScreen.main.bounds.height >= 812 ? 44.0 : 20.0) as CGFloat

/// 底部间隙
//public let YN_DEVICE_BOTTOM = (UIScreen.main.bounds.height >= 812 ? 30.0 : 0) as CGFloat
public let YN_DEVICE_BOTTOM: CGFloat = {
    guard #available(iOS 11.0, *), let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets, safeAreaInsets.bottom > 0.0 else {
        return 0.0
    }
    return 30.0
} ()

/// 导航栏高度获取
public let YN_NAV_HEIGHT = (UIApplication.shared.statusBarFrame.height + 44 ) as CGFloat

/// 状态栏高度获取
public let YN_STATUSBAR_HEIGHT = (UIApplication.shared.statusBarFrame.height) as CGFloat

///  TABBAR 高度获取
public let YN_TAB_HEIGHT =  (UIScreen.main.bounds.size.height >= 812 ? 83 : 49) as CGFloat

/// 苹方-简 中黑体
public let YNPingFangMediumFontName = "PingFangSC-Medium"
/// 苹方-简 中粗体
public let YNPingFangSemiboldFontName = "PingFangSC-Semibold"
/// 苹方-简 常规体
public let YNPingFangRegularFontName = "PingFangSC-Regular"

/// 字体缩放
public func gScale(_ a : CGFloat) -> CGFloat{
    return a * YN_SCREEN_WIDTH / 375.0
}
///Normal字体
public func YNFont(_ fontSize : CGFloat) -> UIFont{
    //return UIFont.systemFont(ofSize: fontSize)
    return UIFont.init(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
}

///加粗字体
public func YNBoldFont(_ fontSize : CGFloat) -> UIFont{
    //return UIFont.boldSystemFont(ofSize: fontSize)
    return UIFont.init(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
}

///Normal字体(随机型适配)
public func YNFont_Fit(_ fontSize : CGFloat) -> UIFont{
    //return UIFont.systemFont(ofSize: fontSize)
    return UIFont.init(name: "PingFangSC-Regular", size: fontSize.fit) ?? UIFont.systemFont(ofSize: fontSize)
}

///MediumFont字体(随机型适配)
public func YNMediumFont_Fit(_ fontSize : CGFloat) -> UIFont{
    //return UIFont.systemFont(ofSize: fontSize)
    return UIFont.init(name: "PingFangSC-Medium", size: fontSize.fit) ?? UIFont.boldSystemFont(ofSize: fontSize)
}

///Semibold字体(随机型适配)
public func YNSemiboldFont_Fit(_ fontSize : CGFloat) -> UIFont{
    //return UIFont.systemFont(ofSize: fontSize)
    return UIFont.init(name: "PingFangSC-Semibold", size: fontSize.fit) ?? UIFont.boldSystemFont(ofSize: fontSize)
}

//MARK:单例
public let YNAppdelegate = UIApplication.shared.delegate
public let YNUserDefaults = UserDefaults.standard
public let YNNotiCenter:NotificationCenter = NotificationCenter.default


// MARK: 其他实用
//Bundle
public let YNBundle:Bundle = Bundle.main
//是否是iPad
public let YNIsPad:Bool  = UIDevice.current.model == "iPad"

//MARK:版本号相关
let YNInfo = Bundle.main.infoDictionary ?? YNDefaultDic()
let YNDisplayName   = YNInfo["CFBundleDisplayName"]               //程序名称
let YNShortVersion  = YNInfo["CFBundleShortVersionString"]        //主程序版本号
let YNBuildVersion  = YNInfo["CFBundleVersion"]                   //版本号（内部标示）
let YNBundleId      = YNInfo["CFBundleIdentifier"]                //bundleId
let YNProjectName   = YNInfo["CFBundleExecutable"]                //工程名

///设备信息
let YNDeviceVersion = UIDevice.current.systemVersion //iOS版本
let YNDeviceUdid = UIDevice.current.identifierForVendor //设备udid
let YNDeviceSystemName = UIDevice.current.systemName //设备名称
let YNDeviceModel = UIDevice.current.model //设备型号
let YNDeviceName = UIDevice.current.name //设备具体型号
let YNDeviceLocalizedModel = UIDevice.current.localizedModel //设备区域化型号如A1533

public let YNTip = "操作失败，请重试"

public func showDefaultTip(){
    YNKeyWindow()?.yn_showToast("操作成功~")
}

// MARK: 常用颜色设置
//MARK: 颜色
/// rgb获取颜色-不带透明度
public func YNRGB(_ red: CGFloat, _ green: CGFloat , _ blue: CGFloat, alhpa: CGFloat = 1.0) -> UIColor {
    return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alhpa)
}

///rgb获取颜色-带透明度
public func YNRGBA (_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)-> UIColor{
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

///随机色的
public func YNRandomColor () -> UIColor {
    let red = CGFloat(arc4random()%256)/255.0
    let green = CGFloat(arc4random()%256)/255.0
    let blue = CGFloat(arc4random()%256)/255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

///HexColor 支持0xFF55c9c4格式
public func YNHexColor(_ argb: UInt32) -> UIColor {
    return UIColor(red: ((CGFloat)((argb & 0xFF0000) >> 16)) / 255.0,green: ((CGFloat)((argb & 0xFF00) >> 8)) / 255.0,blue: ((CGFloat)(argb & 0xFF)) / 255.0, alpha: 1.0)
}

///HexString 支持"#55c9c4"和"55c9c4"格式
public func YNHexString(_ hexString: String?) -> UIColor {
    guard let hexString = hexString else {
        return UIColor.clear
    }
    return hexString.yn_toUIColor()
}
public func YNHexString(_ hexString: String? , alpha: CGFloat = 1.0) -> UIColor {
    guard let hexString = hexString else {
        return UIColor.clear
    }
   return  hexString.yn_toUIColor().withAlphaComponent(alpha)
}

///延迟加载 - delay
public func YNDelay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// MARK: - 图片
public func YNImage(_ imageName: String) -> UIImage {
    return UIImage.init(named: imageName) ?? UIImage()
}

//时间戳
public func YN_TIMESTAMP() -> String{
    return "\(Date().timeIntervalSince1970)"
}

//MARK:颜色其他
public let COLOR_MAIN:UIColor = YNHexString("#0A6EF0") //主体颜色
public let NAV_BGCOLOR:UInt32 = 0xFF0b0f48 //导航条颜色

public let YNRed:UIColor = UIColor.red
public let YNBlue:UIColor = UIColor.blue
public let YNGreen:UIColor = UIColor.green
public let YNYellow:UIColor = UIColor.yellow
public let YNCyan:UIColor = UIColor.cyan
public let YNWhite:UIColor = UIColor.white
public let YNBlack:UIColor = UIColor.black
public let YNClear:UIColor = UIColor.clear

/// 安全区适配
/// 顶部安全区
public func YNTOP_SAFE_AREA () -> CGFloat {

    if #available(iOS 11.0, *) {
        return YNKeyWindow()?.safeAreaInsets.top ?? 0
    } else {
        return 0
    }
}
/// 底部部安全区
public func YNBOTTOM_SAFE_AREA () -> CGFloat {

    if #available(iOS 11.0, *) {
        return YNKeyWindow()?.safeAreaInsets.bottom ?? 0
    } else {
        return 0
    }
}

/// IPHONEX
public func YN_IPHONEX () -> Bool {

    if #available(iOS 11.0, *) {
        return YNKeyWindow()?.safeAreaInsets.bottom ?? 0 > 0 ? true : false
    } else {
        return false
    }
}

func YN_IPHONEX_INSETS()->UIEdgeInsets{
    
    if #available(iOS 11.0, *) {
        return YNKeyWindow()?.safeAreaInsets ?? UIEdgeInsets.zero
    } else {
       return UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
    }
}

/** Getting keyWindow. */
public func YNKeyWindow() -> UIWindow? {
    
    struct Static {
        /** @abstract   Save keyWindow object for reuse.
        @discussion Sometimes [[UIApplication sharedApplication] keyWindow] is returning nil between the app.   */
        static weak var keyWindow: UIWindow?
    }

    var originalKeyWindow : UIWindow? = nil
    
    #if swift(>=5.1)
    if #available(iOS 13, *) {
        originalKeyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    } else {
        originalKeyWindow = UIApplication.shared.keyWindow
    }
    #else
    originalKeyWindow = UIApplication.shared.keyWindow
    #endif

    
    
    //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
    if let originalKeyWindow = originalKeyWindow {
        Static.keyWindow = originalKeyWindow
    }

    //Return KeyWindow
    return Static.keyWindow
}

//MARK: debug打印
public func YNLog<T>(_ message : T,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG || ADHOC
    print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

extension String {
    /// 将十六进制颜色转伟UIColor
    /// - Returns: UIColor
    public func yn_toUIColor() -> UIColor {
        //处理数值
        var cString = self.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            return UIColor.white
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}

public class YNMacro: NSObject {
    
    public static let scale : CGFloat = {
        return CGFloat(YN_SCREENMIN / 375.0)
    }()
    
    static let shared = YNMacro()
    
    var dateFormate = DateFormatter()
    
    var today : String {
        dateFormate.dateFormat = "yyyy-MM-dd"
        return dateFormate.string(from: Date())
    }
    
    var navbarHeight : CGFloat {
        get{
            if YN_IsIphoneX{return 88}
            return 64
        }set{}
    }
    
    var tabbarHeight : CGFloat {
        get{
            if YN_IsIphoneX{return 83}
            return 49
        }set{}
    }
    
    var statusbarHeight : CGFloat{
        get{
            if YN_IsIphoneX{return 44}
            return 20
        }set{}
    }
    
    //设置日期显示格式
    public  func  formatDate(_ date:Date, _ dateStr:String) -> String{
        let formatter:DateFormatter = DateFormatter.init()
        formatter.dateFormat = dateStr
        return formatter.string(from: date as Date)
    }
    
    public func getTimeStamp(sinceNow:TimeInterval) -> String{
        
        let date = Date(timeIntervalSinceNow: sinceNow)
        let a = date.timeIntervalSince1970*1000
        let timeS = NSString(format: "%.0f", a)
        return timeS as String
    }
    
    func getSystemVolume() -> Float {
        return AVAudioSession.sharedInstance().outputVolume
    }
}
