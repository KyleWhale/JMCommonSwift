//
//  DispatchQueue+Extension.swift
//  YNBase
//
//  Created by guo hongquan on 2021/6/16.
//  DispatchQueue扩展

import Foundation

extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        guard !_onceTracker.contains(token) else { return }
        
        _onceTracker.append(token)
        block()
    }
}
