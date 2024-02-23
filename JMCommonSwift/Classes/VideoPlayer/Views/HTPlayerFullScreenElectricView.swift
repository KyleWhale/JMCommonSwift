//
//  HTPlayFullScreenElectricView.swift
//  Cartoon
//
//  Created by James on 2023/5/8.
//

import Foundation
import UIKit

class HTPlayerFullScreenElectricView:UIView {
    
    private var electricOutTimer: HTGCDTimer?
    
    private lazy var contentView: UIView = {
       let contentView = UIView()
        contentView.backgroundColor = .clear
       return contentView
    }()
    
    private lazy var batteryView: HTBatteryIconView = {
        
        let batteryView = HTBatteryIconView()
        return batteryView
    }()
    
    private lazy var batteryBoltImageView: UIImageView = {
        
        let imageView = UIImageView()
        if let image = UIImage(systemName: "bolt") {
            imageView.image = image
            imageView.tintColor = .white
        }
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.init(name: "Helvetica-Helvetica", size: 8.fit) ?? UIFont.systemFont(ofSize: 8.fit)
        label.text = Date().yn_toString("HH:mm")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        jm_viewPrepare()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jm_viewPrepare() {
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.addSubview(batteryView)
        batteryView.snp.makeConstraints { make in
            
            if HTConstIsiPad {
                make.top.equalTo(9)
                make.width.equalTo(15.75)
                make.height.equalTo(8.59)
            }
            else {
                make.top.equalTo(9.fit)
                make.width.equalTo(15.75.fit)
                make.height.equalTo(8.59.fit)
            }
            
            make.centerX.equalTo(contentView)
        }
        
        contentView.addSubview(batteryBoltImageView)
        batteryBoltImageView.snp.makeConstraints { make in
            make.center.equalTo(batteryView)
            if HTConstIsiPad {
                make.height.equalTo(12)
            }
            else {
                make.height.equalTo(12.fit)
            }
            
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            if HTConstIsiPad {
                make.top.equalTo(batteryView.snp.bottom).offset(4)
            }
            else {
                make.top.equalTo(batteryView.snp.bottom).offset(4.fit)
            }
            
            make.centerX.equalTo(contentView)
        }
        
        jm_initDevice()
    }
    
    func jm_initDevice() {
        let device = UIDevice.current
                
        device.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(_:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(_:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        
        let batteryLevel = device.batteryLevel
        let batteryState = device.batteryState
        
        print("Battery Level: \(batteryLevel)")
        print("Battery State: \(batteryState)")
        
        batteryView.battery = CGFloat(batteryLevel)
        
        if batteryState == .charging {
            
            batteryView.setFillColor(.green)
            
            batteryBoltImageView.isHidden = false
        }
        else {
            batteryView.setFillColor(.white)
            
            batteryBoltImageView.isHidden = true
        }
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        let device = notification.object as! UIDevice
        let batteryLevel = device.batteryLevel
        
        print("Battery Level Did Change: \(batteryLevel)")
        
        batteryView.battery = CGFloat(batteryLevel)
    }
        
    @objc func batteryStateDidChange(_ notification: Notification) {
        let device = notification.object as! UIDevice
        let batteryState = device.batteryState
        
        print("Battery State Did Change: \(batteryState)")
        
        if batteryState == .charging {
            
            batteryView.setFillColor(.green)
            
            batteryBoltImageView.isHidden = false
        }
        else {
            batteryView.setFillColor(.white)
            
            batteryBoltImageView.isHidden = true
        }
    }
    
    public func jm_autoElectricTimer() {
        electricOutTimer = HTGCDTimer(interval: 0, delaySecs: 1, repeats: false, action: { [weak self] _ in
            
            if let self = self {
                
                let time = Date().yn_toString("HH:mm")
                
                self.timeLabel.text = time
                
            }
        })
        electricOutTimer?.start()
    }

    public func jm_cancelElectricTimer() {
        electricOutTimer?.cancel()
    }
    
    func jm_getBatteryIcon() -> UIImage? {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

        let batteryLevel = device.batteryLevel
        let batteryState = device.batteryState

        var batteryIconName: String
        
        switch batteryState {
        case .charging:
            batteryIconName = "battery.charging"
        case .full:
            batteryIconName = "battery.full"
        case .unplugged, .unknown:
            if batteryLevel < 0.2 {
                batteryIconName = "battery.low"
            } else {
                batteryIconName = "battery"
            }
        @unknown default:
            batteryIconName = "battery"
        }
        
        device.isBatteryMonitoringEnabled = false
        
        return UIImage(systemName: batteryIconName)
    }
    
    deinit {
        
        jm_cancelElectricTimer()
        
        NotificationCenter.default.removeObserver(self)
    }
}
