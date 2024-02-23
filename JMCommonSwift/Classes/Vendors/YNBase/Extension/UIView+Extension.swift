//
//  UIView+Extension.swift
//  YNBase
//
//  Created by James on 2021/5/19.
//

import Foundation
import UIKit

public extension UIView {
    
    //Colors：渐变色色值数组
    func setGradientColorsAndVertical(_ colors:[CGColor], _ vertical:Bool) -> Void  {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 0)
        if vertical {
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        else
        {
            layer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        self.layer.addSublayer(layer)
    }
    
    /// 设置渐变色
    /// - Parameters:
    ///   - layerSize: 要实现渐变View 的 layer 的size
    ///   - colors: 渐变色色值数组
    ///   - vertical: 方向
    /// - Returns:
    func setGradientColorsAndVertical( _ layerSize:CGSize, _ colors:[CGColor], _ vertical:Bool) -> Void  {
        let layer = CAGradientLayer()
        layer.frame = CGRect.init(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 0)
        if vertical {
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        else
        {
            layer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        self.layer.addSublayer(layer)
    }
    
    func yn_getGradientColorsAndVertical(_ colors:[CGColor], _ vertical:Bool) -> CAGradientLayer  {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 0)
        if vertical {
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
        else
        {
            layer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        return layer
    }
    
    /// 圆角设置
    /// - Parameters:
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: Void
    func setCornerWithCorners(_ corners:UIRectCorner, _ cornerRadii:CGSize) -> Void  {
        self.layoutIfNeeded()
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}


public func yn_gradientLayer(_ colors: [CGColor], _ vertical: Bool) -> CAGradientLayer  {
    let layer = CAGradientLayer()
    layer.frame = CGRect.zero
    layer.colors = colors
    layer.startPoint = CGPoint(x: 0, y: 0)
    if vertical {
        layer.endPoint = CGPoint(x: 0, y: 1)
    } else {
        layer.endPoint = CGPoint(x: 1, y: 0)
    }
    return layer
}

