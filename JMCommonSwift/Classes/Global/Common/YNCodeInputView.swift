//
//  YNCodeInputView.swift
//  YNCustomer
//
//  Created by James on 2021/5/20.
//

import Foundation
import UIKit


let K_W:CGFloat = 40

class YNCodeInputView: UIView, UITextViewDelegate {
    
    var iPhone:String = ""
    var verifyCodeDesc:String = ""
    var inputNum:NSInteger = 4
    var lines:NSMutableArray = []
    var labels:NSMutableArray = []
    
    typealias SelectCodeBlock = (_ code:String)->Void;
    var block : SelectCodeBlock?;
    
    private lazy var textView: UITextView = {
        
        let textView = UITextView()
        textView.tintColor = UIColor.clear;
        textView.backgroundColor = UIColor.clear;
        textView.textColor = UIColor.clear;
        textView.delegate = self;
        textView.keyboardType = UIKeyboardType.numberPad;
        // 键盘显示验证码
        if #available(iOS 12.0, *){
            textView.textContentType = UITextContentType.oneTimeCode;
        }
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithSelectCodeBlock( _ inputNum: NSInteger, _ codeBlock:@escaping SelectCodeBlock) {
        
        self.block = codeBlock
        self.inputNum = inputNum
        
        initSubviews()
    }
    
    func initSubviews() {
        
        let W = self.frame.size.width
        let H = self.frame.size.height
        let Padd = ((CGFloat)(W-CGFloat(self.inputNum)*K_W))/((CGFloat)(self.inputNum+1))
        self.addSubview(self.textView)
        self.textView.frame = CGRect.init(x: Padd, y: 0, width: W-Padd*2, height: H)
        beginEdit()
        for i in 0..<self.inputNum {
            
            let subView = UIView()
            subView.frame = CGRect.init(x: Padd+(K_W+Padd)*CGFloat(i), y: 0, width: K_W, height: H)
            subView.isUserInteractionEnabled = false
            self.addSubview(subView)
            
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 0, width: K_W, height: H)
            label.textAlignment = NSTextAlignment.center
            label.font = YNSemiboldFont_Fit(25)
            label.textColor = YNHexString("#4A4A4A")
            label.backgroundColor = YNHexString("#F1F3F7")
            subView.addSubview(label)
            
            let path = UIBezierPath.init(rect: CGRect.init(x: K_W / 2, y: 9, width: 2, height: H - 18))
            let line = CAShapeLayer.init()
            line.path = path.cgPath;
            line.fillColor = UIColor.theme.cgColor
            subView.layer.addSublayer(line)
            
            //CALayer.addSubLayerWithFrame(CGRect.init(x: 0, y: H-2, width: K_W, height: 2), YNHexString("#DDDDDD"), subView)
            
            if i == 0 {
                line.add(opacityAnimation(), forKey: "kOpacityAnimation")
                line.isHidden = false
            }
            else
            {
                line.isHidden = true
            }
            
            //把光标对象和label对象装进数组
            self.lines.add(line)
            self.labels.add(label)
        }
    }
    
    func beginEdit() {
        self.textView.becomeFirstResponder()
    }
    
    func endEdit() {
        self.textView.resignFirstResponder()
    }
    
    func opacityAnimation() -> CABasicAnimation {
        
        let opacityAnimation = CABasicAnimation.init(keyPath: "opacity")
        opacityAnimation.fromValue = (1.0)
        opacityAnimation.toValue = (0.0)
        opacityAnimation.duration = 0.9
        opacityAnimation.repeatCount = HUGE
        opacityAnimation.isRemovedOnCompletion = true
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        opacityAnimation.timingFunction=CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        return opacityAnimation
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let verStr = textView.text ?? ""
        if verStr.yn_length>self.inputNum {
            textView.text = textView.text.yn_subString(start: 0, length: self.inputNum)
        }
        
        if verStr.yn_length>=self.inputNum {
            endEdit()
        }
        
        self.block?(verStr)
        
        for i in 0..<self.labels.count {
            
            let bgLabel = self.labels[i] as? UILabel
            
            if verStr.yn_length>i {
                changeViewLayerIndex(i, true)
                bgLabel?.text = verStr.yn_subString(start: i, length: 1)
            }
            else
            {
                var hidden = true
                if i == verStr.yn_length {
                    hidden = false
                }
                changeViewLayerIndex(i, hidden)
                if verStr.yn_length == 0 {
                    changeViewLayerIndex(0, false)
                }
                bgLabel?.text = ""
            }
        }
    }
    
    func changeViewLayerIndex(_ index:NSInteger,_ hidden:Bool) {
        
        //let line = (CAShapeLayer)(layer: self.lines[index])
        let line = (self.lines[index]) as? CAShapeLayer
        if hidden {
            line?.removeAnimation(forKey: "kOpacityAnimation")
        }
        else
        {
            line?.add(opacityAnimation(), forKey: "kOpacityAnimation")
        }
        
        UIView.animate(withDuration: 0.25) {
            line?.isHidden = hidden
        }
    }
}
