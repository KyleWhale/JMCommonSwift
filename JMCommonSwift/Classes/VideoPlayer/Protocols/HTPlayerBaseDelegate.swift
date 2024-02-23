//
//  HTPlayerBaseDelegate.swift
//  Cartoon
//
//  Created by James on 2023/5/5.
//

import Foundation
import UIKit

public protocol HTPlayerBaseDelegate: AnyObject {
    
    func didPlaybackEnds(in player: HTPlayerBaseView)
    
    func observeStatusAction(in player: HTPlayerBaseView)
    
    func setProgress(in player: HTPlayerBaseView, progress: Double, animation: Bool)
    
    func bufferingSomeSecond(in player: HTPlayerBaseView)
    
    func sliderTimerAction(in player: HTPlayerBaseView)
    
    func didKaDunCount(in player: HTPlayerBaseView, count kaCount:Int)
}
