//
//  YNProtocols.swift
//  YNSwiftMacro
//
//  Created by james on 2021/4/22.
//

import Foundation
/// 按钮点击协议
protocol YNButtonClickable : NSObjectProtocol{
    func didClickButton()
}


/// 数据绑定cell 协议
public protocol YNCell {
    func setData<T>(_ data:T, index : Int)
}



