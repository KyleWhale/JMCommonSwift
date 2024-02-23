//
//  HTBrightnessSliderView.swift
//  JMSwiftCommon
//
//  Created by James on 2023/6/26.
//

import Foundation
import UIKit

let STATIC_BrightnessSliderViewWidth:CGFloat = 200

class HTBrightnessSliderView:UIView {
    
    public var var_sliderValue:Double = 0.0 {
        didSet {
            
            var var_sliderValueTemp = var_sliderValue
            
            if var_sliderValueTemp <= 0.01 {
                
                var_sliderValueTemp = 0.01
            }
            
            // 获取当前屏幕亮度，并设置滑块的初始值
            let sliderWidth = var_sliderValueTemp*STATIC_BrightnessSliderViewWidth
            
            UIView.animate(withDuration: 0.25) {
                
                self.var_SliderView.snp.updateConstraints { make in
                    make.width.equalTo(sliderWidth)
                }
               
                self.var_ContentView.layoutIfNeeded()
            }
        }
    }
    
    enum HTPanDirection {
        case unknow
        case horizontal
        case leftVertical
        case rightVertical
    }
    
    private var panDirection: HTPanDirection = .unknow
    
    var var_isTouch:Bool = false
    
    public lazy var var_ContentView: UIView = {
        let view = UIView()
        view.backgroundColor = YNHexString("#000000",alpha: 0.5)
        return view
    }()
    
    public lazy var var_SliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var var_LeftIconImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = HTImageHelper.imageWithName("icon_pleyar_light") {
            imageView.image = image
            imageView.tintColor = .black
        }
        return imageView
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(jm_panDirection(_:)))
        gesture.maximumNumberOfTouches = 1
        gesture.delaysTouchesBegan = true
        gesture.delaysTouchesEnded = true
        gesture.cancelsTouchesInView = true
        //gesture.delegate = self
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        jm_init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jm_init() {
        
        addSubview(var_ContentView)
        var_ContentView.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(STATIC_BrightnessSliderViewWidth)
        }
        
        var_ContentView.layer.cornerRadius = 8.fit
        var_ContentView.layer.masksToBounds = true
        
        // 获取当前屏幕亮度，并设置滑块的初始值
        let sliderWidth = UIScreen.main.brightness*STATIC_BrightnessSliderViewWidth
        
        var_ContentView.addSubview(var_SliderView)
        var_SliderView.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(var_ContentView)
            make.width.equalTo(sliderWidth)
        }
        
        addSubview(var_LeftIconImageView)
        var_LeftIconImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(6.fit)
            make.centerY.equalTo(self)
        }
        
        addGestureRecognizer(panGesture)
    }
    
    @objc func jm_panDirection(_ pan: UIPanGestureRecognizer) {
        let locationPoint = pan.location(in: self)
        let veloctyPoint = pan.velocity(in: self)
        switch pan.state {
        case .began:
            
            var_isTouch = true
            
            if abs(veloctyPoint.x) > abs(veloctyPoint.y) {
                //print("veloctyPoint.x = \(veloctyPoint.x) veloctyPoint.y = \(veloctyPoint.y)")
                panDirection = .horizontal
            } else {
                panDirection = locationPoint.x < bounds.width * 0.5 ? .leftVertical : .rightVertical
            }
            
            
            
        case .changed:
            switch panDirection {
            case .horizontal:
                
                let value = veloctyPoint.x / 10000
                
                print("\n leftVertical veloctyPoint.x / 10000 = \(value)")
  
                var_sliderValue += value
                
                UIScreen.main.brightness += value
                
                break
            case .leftVertical:
                
                break
            case .rightVertical:
                
                break
                
            default:
                break
            }
        case .ended, .cancelled:
            
            var_isTouch = false
            
            if panDirection == .horizontal {
                
            }
            
            panDirection = .unknow

            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                
                DispatchQueue.main.async {

                    self.isHidden = true
                }
            }
     
        default:
            break
        }
    }
    
    public func jm_hidden() {
        
        if !var_isTouch {
            
            self.isHidden = true
        }
    }
}
