//
//  YNGlobal.swift
//  YNCustomer
//
//  Created by james on 2021/5/6.
//
import Foundation
import UIKit

/// 通用接口延迟时间
public let YN_DELAY_REFRESH_TIME:TimeInterval = 2

//MRAK: 应用默认颜色
extension UIColor {
    class var background: UIColor {
        return YNHexString("#F2F2F2")
    }
    
    // 主题色
    class var theme: UIColor {
        return YNHexString("#0A6EF0")
    }
    
    // 次主题色
    class var themeSecondary: UIColor {
        return YNHexString("#4693F8")
    }
    
    // 弱主题色
    class var themeWeek: UIColor {
        return YNHexString("#B8D7FF")
    }
    
    class var titleTextColor: UIColor {
        return YNRGB(51, 51,51)
    }
    
    class var descriptionTextColor: UIColor {
        return YNRGB(153, 153,153)
    }
    
    // 重要文字
    class var importainTextColor: UIColor {
        return YNHexString("#FFA000")
    }
    
    // 次要文字
    class var secondaryTextColor: UIColor {
        return YNHexString("#FFB740")
    }
    
    // 弱文字
    class var weakTextColor: UIColor {
        return YNHexString("#FFCA73")
    }
    
    // 不可用文字
    class var disableTextColor: UIColor {
        return YNHexString("#FF6400")
    }
    
    // 弱按钮
    class var weekButtonTextColor: UIColor {
        return YNHexString("#4380D3")
    }
    
}

extension String {
    static let searchHistoryKey = "searchHistoryKey"
    static let sexTypeKey = "sexTypeKey"
    static let visitorKey = "visitorKey"
}

extension NSNotification.Name {
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
    static let YNDidPublishLine = NSNotification.Name("YNDidPublishLine")
}

public let APP_SCHEME = "wutongdriver"

var yn_topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC(YNKeyWindow()?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC
}
private  func _topVC(_ vc: UIViewController?) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    } else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    } else {
        return vc
    }
}
////MARK: SnapKit
//extension ConstraintView {
//
//    var usnp: ConstraintBasicAttributesDSL {
//        if #available(iOS 11.0, *) {
//            return self.safeAreaLayoutGuide.snp
//        } else {
//            return self.snp
//        }
//    }
//}

extension UICollectionView {
    
    func reloadData(animation: Bool = true) {
        if animation {
            reloadData()
        } else {
            UIView .performWithoutAnimation {
                reloadData()
            }
        }
    }
}

extension UIFont {
    open class func mediumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

