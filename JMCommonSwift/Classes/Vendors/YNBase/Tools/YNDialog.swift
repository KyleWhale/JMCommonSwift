//
//  YNDialog.swift
//  YNCustomer
//
//  Created by james on 2021/5/8.
//

import Foundation

import UIKit

public extension UIViewController {
    
    /*
     单个按钮使用案例
     yn_alertWith(title: "提示", message: "是否确定【司机名称/185xxxx0005】配送该线路？确定后可电话联系该司机!",cancelTitle: "") {
         
     } cancel: {
         
     }
     */
    
    /// 弹窗弹出提示
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - cancelTitle: 取消标题
    ///   - ensureTitle: 确定标题
    ///   - ensure: 确认回调
    ///   - cancel: 取消回调
    func yn_alertWith(title:String,message:String,cancelTitle:String = "取消",ensureTitle:String = "确认", ensure:@escaping() -> Void,cancel:@escaping() -> Void) {

        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)

        if !cancelTitle.isEmpty {
            let cancleAlert = UIAlertAction.init(title: cancelTitle, style: .default) { (UIAlertAction) in
                cancel()
            }
            alertView.addAction(cancleAlert)
        }
        
        if !ensureTitle.isEmpty {
            let alert = UIAlertAction.init(title: ensureTitle, style: .destructive) { (UIAlertAction) in
                ensure()
            }
            alertView.addAction(alert);
        }
        
        
        self.present(alertView, animated: true, completion: nil)
    }

}

