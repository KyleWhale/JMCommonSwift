//
//  HTPlayerContentViewDelegate.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import AVFoundation
import Foundation
import UIKit

protocol HTPlayerContentViewDelegate: AnyObject {
    
    func jm_didClickFailButton(in contentView: HTPlayerBaseContentView)

    func jm_didClickBackButton(in contentView: HTPlayerBaseContentView)

    func contentView(_ contentView: HTPlayerBaseContentView, didClickPlayButton isPlay: Bool)

    func contentView(_ contentView: HTPlayerBaseContentView, didClickFullButton isFull: Bool)

    func contentView(_ contentView: HTPlayerBaseContentView, didChangeRate rate: Float)

    func contentView(_ contentView: HTPlayerBaseContentView, didChangeVideoGravity videoGravity: AVLayerVideoGravity)

    func contentView(_ contentView: HTPlayerBaseContentView, sliderTouchBegan slider: HTSlider)

    func contentView(_ contentView: HTPlayerBaseContentView, sliderValueChanged slider: HTSlider)

    func contentView(_ contentView: HTPlayerBaseContentView, sliderTouchEnded slider: HTSlider)
    
    func jm_didClickPlayBackUpButton(in contentView: HTPlayerBaseContentView)
    
    func jm_didClickPlayAdvanceButton(in contentView: HTPlayerBaseContentView)
    
    func jm_didClickPlayLockButton(in contentView: HTPlayerBaseContentView, lock isLock:Bool)
    
    func jm_didClickPlayRemoveADButton(in contentView: HTPlayerBaseContentView)
    
    func jm_didClickPlayNextEpisodeButton(in contentView: HTPlayerBaseContentView)
    
    func jm_didClickPlaySelectEpisodeButton(in contentView: HTPlayerBaseContentView, button buttonView:UIButton, index indexForButton:Int)
    
    func jm_didClickSubTitleSettingButton(in contentView: HTPlayerBaseContentView,fullState isFullState:Bool, button buttonView:UIButton, index indexForButton:Int)
    
    func jm_didClickShareButton(in contentView: HTPlayerBaseContentView)
    
    func jm_contentView(_ contentView: HTPlayerBaseContentView, subTitleLoadComplete parsedPayload: NSDictionary?)
    
    func jm_didClickFastForward(_ contentView: HTPlayerBaseContentView, fastForwardTime timeSecond: Double)
}
