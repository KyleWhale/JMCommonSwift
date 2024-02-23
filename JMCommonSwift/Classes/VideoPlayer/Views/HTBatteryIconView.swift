//
//  HTCustomElectricView.swift
//  Cartoon
//
//  Created by James on 2023/5/8.
//

import Foundation

class HTBatteryIconView:UIView {
    
    public var battery:CGFloat = 0.5
    
    public func setBattety( _ battery: CGFloat) {
        
        self.battery = battery
        
        self.setNeedsDisplay()
    }
    
    public var fillColor:UIColor = .white
    
    public func setFillColor( _ fillColor: UIColor) {
        
        self.fillColor = fillColor
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            // 设置电池边框的宽度和圆角
            let borderWidth: CGFloat = 1.0
            let cornerRadius: CGFloat = 2.0
            
            // 计算电池的宽度和高度
            let batteryWidth = rect.width - borderWidth * 2
            let batteryHeight = rect.height - borderWidth * 2
            
            // 计算电池内部的填充区域
            let fillRect = CGRect(x: borderWidth+batteryWidth * 0.1, y: borderWidth+batteryHeight * 0.2, width: batteryWidth * battery, height: batteryHeight * 0.6)
            
            // 设置电池边框路径
            let borderPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            borderPath.lineWidth = borderWidth
            
            // 绘制电池边框
            UIColor.white.setStroke()
            borderPath.stroke()
            
            // 绘制电池填充区域
            self.fillColor.setFill()
            context.fill(fillRect)
        }
    
}
