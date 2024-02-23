//
//  YNTextFieldExt.swift
//  YNCustomer
//
//  Created by james on 2021/5/6.
//

import UIKit
public extension UITextField {
    
    
    /// 设置最大可输入限制
    /// - Parameters:
    ///   - limit: 最大值
    ///   - error: 错误信息展示
    func yn_maxLimit(_ limit: Int, errorMessage error: String? = nil) {
        self.maxLimit = limit
        self.errorMessage = error
        addTarget(YNInputProtocol.shared, action: YNInputProtocol.shared.textFieldSelector, for: .editingChanged)
    }
    
    private struct RuntimeKey {
        static var maxLimitKey = "maxLimitKey"
        static var errorMessageKey = "errorMessageKey"
    }
    
    internal var maxLimit: Int {
        get {
            
            return objc_getAssociatedObject(self, &RuntimeKey.maxLimitKey) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &RuntimeKey.maxLimitKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var errorMessage: String? {
        get {
            return objc_getAssociatedObject(self, &RuntimeKey.errorMessageKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &RuntimeKey.errorMessageKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func inputToFitDecimalPad(_ string: String) -> Bool {
        guard keyboardType == .decimalPad else {
            return true
        }
        guard string != "" else {
            return true
        }
        if text == "0" && string != "." {
            text = ""
        } else if (text == nil || text ?? "" == "") && string == "." {
            text = "0"
        } else {
            guard let text = text else {
                return true
            }
            guard let index = text.firstIndex(of: ".") else {
                return true
            }
            let subString = text[index ..< text.endIndex]
            guard subString.count < 3 else {
                return false
            }
        }
        return true
    }
}

public extension UITextView {
    
    /// 设置最大可输入限制
    /// - Parameters:
    ///   - limit: 最大值
    ///   - error: 错误信息展示
    func yn_maxLimit(_ limit: Int, errorMessage: String? = nil) {
        self.maxLimit = limit
        self.errorMessage = errorMessage
        self.delegate = YNInputProtocol.shared
    }
    
    private struct RuntimeKey {
        static var maxLimitKey = "maxLimitKey"
        static var errorMessageKey = "errorMessageKey"
        static var placeholderLabelKey = "placeholderLabelKey"
        static var yn_delegateKey = "yn_delegateKey"
    }
    
    weak var yn_delegate: UITextViewDelegate? {
        get {
            return objc_getAssociatedObject(self, &RuntimeKey.yn_delegateKey) as? UITextViewDelegate
        }
        set {
            objc_setAssociatedObject(self, &RuntimeKey.yn_delegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var maxLimit: Int {
        get {
            guard let temp = objc_getAssociatedObject(self, &RuntimeKey.maxLimitKey) else { return 0 }
            
            return temp as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &RuntimeKey.maxLimitKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    internal var errorMessage: String? {
        get {
            return objc_getAssociatedObject(self, &RuntimeKey.errorMessageKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &RuntimeKey.errorMessageKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    fileprivate func textDidChanged() {
        if placeholderText != nil {
            placeholderLabel?.isHidden = (text.lengthOfBytes(using: .utf8) != 0)
        }
        guard maxLimit > 0 else {
            return
        }
        let language = textInputMode?.primaryLanguage
        if language == "zh-Hans"  {
            if var text = text,
               markedTextRange == nil && text.yn_length > maxLimit {
                let index = text.index(text.startIndex, offsetBy: maxLimit)
                text = String(text[..<index])
                if let errorMessage = errorMessage {
                    YNKeyWindow()?.yn_showToast(errorMessage)
                }
            }

        } else {
            if text.yn_length > maxLimit {
                let index = text.index(text.startIndex, offsetBy: maxLimit)
                text = String(text[..<index])
                if let errorMessage = errorMessage {
                    YNKeyWindow()?.yn_showToast(errorMessage)
                }
            }
        }
    }
    
    internal var placeholderLabel: UILabel? {
        get {
            return objc_getAssociatedObject(self, &RuntimeKey.placeholderLabelKey) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &RuntimeKey.placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var placeholderText: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel == nil {
                placeholderLabel = UILabel.init(frame: CGRect.init(x: 3, y: 7, width: textContainer.size.width - textContainer.lineFragmentPadding * 1.5, height: 18))
                placeholderLabel?.numberOfLines = 0
                placeholderLabel?.text = newValue
                placeholderLabel?.font = font
                if maxLimit == 0 {
                    self.delegate = YNInputProtocol.shared
                }
                placeholderLabel?.sizeToFit()
                placeholderLabel?.textColor = UIColor.lightGray
                if let placeholderLabel = placeholderLabel {
                    addSubview(placeholderLabel)
                }
            }
        }
    }
    
    func clearText() {
        text = ""
        if placeholderText != nil {
            placeholderLabel?.isHidden = false
        }
    }
    
}

fileprivate class YNInputProtocol: NSObject {
    
    static let shared = YNInputProtocol()
}

extension YNInputProtocol {
    
    @objc func textFieldTextDidChanged(_ textfield: UITextField) {
        setInputLimit(for: textfield)
    }
    
    func setInputLimit(for textField: UITextField) {
        let length = textField.maxLimit
        let error = textField.errorMessage
        let language = textField.textInputMode?.primaryLanguage
        let text = textField.text
        if language == "zh-Hans"  {
            if let text = text,
               textField.markedTextRange == nil && text.yn_length > length {
                let index = text.index(text.startIndex, offsetBy: length)
                textField.text = String(text[..<index])
                if let errorMessage = error {
                    YNKeyWindow()?.yn_showToast(errorMessage)
                }
            }
        } else {
            if let text = text, text.yn_length > length {
                let index = text.index(text.startIndex, offsetBy: length)
                textField.text = String(text[..<index])
                if let errorMessage = error {
                    YNKeyWindow()?.yn_showToast(errorMessage)
                }
            }
        }
    }
    
    var textFieldSelector: Selector {
        return #selector(textFieldTextDidChanged(_:))
    }
}

extension YNInputProtocol: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textDidChanged()
        if let delegate = textView.yn_delegate {
            delegate.textViewDidChange?(textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView.returnKeyType == .done else {
            return textView.yn_delegate?.textView?(textView, shouldChangeTextIn: range,replacementText: text) ?? true
        }
        guard text == "\n" else {
            return textView.yn_delegate?.textView?(textView, shouldChangeTextIn: range,replacementText: text) ?? true
        }
        textView.endEditing(true)
        return false
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return textView.yn_delegate?.textViewShouldBeginEditing?(textView) ?? true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.yn_delegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return textView.yn_delegate?.textViewShouldEndEditing?(textView) ?? true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.yn_delegate?.textViewDidEndEditing?(textView)
    }
}
