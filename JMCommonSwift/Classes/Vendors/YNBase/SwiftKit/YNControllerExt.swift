//
//  UIViewController+YNExtension.swift
//  SmartCampusTC
//
//  Created by james on 2019/1/23.
//  Copyright © 2019 李佳. All rights reserved.
//

import UIKit
extension UIViewController {
    
    /// 打印输出ViewController类名：
    public class func yn_logMethod(){
        yn_changeSel(originalSelector: #selector(UIViewController.viewWillAppear(_:)), swizzledSelector: #selector(UIViewController.ynViewWillAppear(_:)))
        yn_changeSel(originalSelector: #selector(UIViewController.viewWillDisappear(_:)), swizzledSelector: #selector(UIViewController.ynViewWillDisaAppear(_:)))
    }
    
    private static func yn_changeSel(originalSelector:Selector?,swizzledSelector:Selector?){
        
        if let originalSelector = originalSelector,
           let swizzledSelector = swizzledSelector,
           let originalMethod = class_getInstanceMethod(self, originalSelector ),
           let swizzledMethod = class_getInstanceMethod(self, swizzledSelector ) {
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod:Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
         
    }
    
    @objc func ynViewWillAppear(_ animated: Bool) {
        // 获取命名空间(Swift 类名格式: 主工程.类名 - ProjectName.UIViewController)
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            print("没有获取命名空间")
            return
        }
        
        var className:String = NSStringFromClass(self.classForCoder)
        if className.contains(nameSpace) {
           className = className.replacingOccurrences(of: "\(nameSpace).", with: "")
        }
        YNLog("viewWillAppear===========\(className)")
        self.ynViewWillAppear(animated)
    }
    
    @objc func ynViewWillDisaAppear(_ animated: Bool) {
        // 获取命名空间(Swift 类名格式: 主工程.类名 - ProjectName.UIViewController)
        guard let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else {
            print("没有获取命名空间")
            return
        }
        
        var className:String = NSStringFromClass(self.classForCoder)
        if className.contains(nameSpace) {
            className = className.replacingOccurrences(of: "\(nameSpace).", with: "")
        }
        YNLog("ynViewWillDisaAppear===========\(className)")
        self.ynViewWillDisaAppear(animated)
    }
    
    
    /// 设置导航栏透明
    /// - Parameter isTransparent: 是否透明
    public func yn_setNavBarTransparent(_ isTransparent: Bool )
    {
        if isTransparent {
            //设置导航栏背景透明
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }else {
            //重置导航栏背景
            self.navigationController?.navigationBar.setBackgroundImage(UIColor.white.yn_image(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
        
    }
}
