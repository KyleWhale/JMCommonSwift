//
//  CALayer+Extension.swift
//  YNBase
//
//  Created by James on 2021/5/20.
//

import Foundation
import UIKit

public extension CALayer {
    //func hk_imageWithColor(color:UIColor)->UIImage
    @objc static func addSubLayerWithFrame(_ frame:CGRect, _ color:UIColor, _ baseView:UIView) {
        let layer = CALayer.init()
        layer.frame = frame
        layer.backgroundColor = color.cgColor
        baseView.layer.addSublayer(layer)
    }
}
