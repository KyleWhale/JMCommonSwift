//
//  HTPlayerBaseObject.swift
//  Cartoon
//
//  Created by James on 2023/5/5.
//

import AVFoundation
import Foundation
import UIKit

public enum HTPlayerStatus : Int {

    case unknown = 0

    case readyToPlay = 1

    case failed = 2
}

public class HTPlayerBaseView:UIView {
    
    public var url: URL?
    
    public var isPlaybackLikelyToKeepUp: Bool = false
    
    //public var currentTime:Double = 0.0
    
    public var rate: Float = 1.0
    
    public weak var delegate: HTPlayerBaseDelegate?
    
    public var playStatus:HTPlayerStatus = .unknown
    
    public var totalDuration:Double = 0.0
    
    init(url: URL?) {
        self.url = url
        super.init(frame: .zero)
        
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
    }
    
    func play() {
        
    }
    
    func pause() {
        
    }
    
    func seekTo(to time: Double) {
        
        
    }
    
    func getCurrentTime() -> Double {
        
        return 0.0
    }
}
