//
//  UIViewController+Extension.swift
//  YNBase
//
//  Created by James on 2021/5/20.
//

import Foundation
import UIKit

public extension UIViewController {
 
    // 导航栏是否隐藏
    func yn_setNavBarHidden(_ isHide:Bool ) {
        
        self.navigationController?.setNavigationBarHidden(isHide, animated: false)
        self.navigationController?.navigationBar.isHidden = isHide
    }
    
    // 隐藏导航条底部的黑线
    func yn_hideNavBarLine() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}
