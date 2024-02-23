//
//  UIButton+Extension.swift
//  YNCustomer
//
//  Created by James on 2021/7/2.
/*
 防止按钮重复点击
 */

import Foundation
import UIKit

public typealias ActionBlock = ((UIButton)->Void)

extension UIButton {
    
    private struct AssociatedKeys {
        static var ActionBlock = "ActionBlock"
        static var ActionDelay = "ActionDelay"
    }
    
    /// 运行时关联
    private var actionBlock: ActionBlock? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionBlock) as? ActionBlock
        }
    }
    
    private var actionDelay: TimeInterval {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionDelay, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionDelay) as? TimeInterval ?? 0
        }
    }
    
    /// 点击回调
    @objc public func btnDelayClick(_ button: UIButton) {
        actionBlock?(button)
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + actionDelay) { [weak self] in
            print("恢复时间\(Date())")
            if let self = self {
                self.isEnabled = true
            }
        }
    }
    
    /// 添加延迟点击事件
    public func addDelayAction(_ delay: TimeInterval = 0, action: @escaping ActionBlock) {
        addTarget(self, action: #selector(btnDelayClick(_:)) , for: .touchUpInside)
        actionDelay = delay
        actionBlock = action
    }
}
