//
//  YNTextField.swift
//  YNCustomer
//
//  Created by James on 2021/5/19.
//

import Foundation
import UIKit

class YNTextField: UITextField {
    
    var isSearchMode:Bool = false
    
    override var keyboardType: UIKeyboardType{
        willSet{
            
        }
        didSet{
            
            if self.keyboardType == UIKeyboardType.decimalPad || self.keyboardType == UIKeyboardType.numberPad {
                
                let bar = UIView()
                bar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 28)
                bar.backgroundColor = UIColor.clear
                let button = UIButton()
                button.frame = CGRect.init(x: UIScreen.main.bounds.size.width-60, y: 0, width: 41, height: 28)
                button .setImage(HTImageHelper.imageWithName("icon_keyboard_packup"), for: UIControl.State.normal)
                button.addTarget(self, action:#selector(keyboardBack(_:)), for:UIControl.Event.touchUpInside)
                button.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
                bar.addSubview(button)
                self.inputAccessoryView = bar
                self.inputView?.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @objc func keyboardBack(_ btn:UIButton) {
//        YNKeyWindow()?.resignFirstResponder()
        self.resignFirstResponder()
    }
    
    @objc public func yn_placeHolder(_ place:String) {
          
        self.attributedPlaceholder = NSAttributedString.init(string: place, attributes:[NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.lightGray])
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        if isSearchMode {
            iconRect.origin.x -= 20 //像右边偏15
        }
        return iconRect
    }
}
