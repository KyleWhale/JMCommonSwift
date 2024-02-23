//
//  UIImage+Extension.swift
//  YNBase
//
//  Created by James on 2021/5/18.
//

import Foundation
import UIKit

public extension UIImage {
    //func hk_imageWithColor(color:UIColor)->UIImage
    @objc static func hk_imageWithColor(color:UIColor) -> UIImage? {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        if let context = context {
            context.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }else {
            return UIImage()
        }
        
    }
}
