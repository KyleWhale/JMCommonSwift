//
//  HTPlayerDelegate.swift
//  Cartoon
//
//  Created by James on 2023/5/5.
//

import Foundation
import UIKit

public protocol HTPlayerDelegate: AnyObject {
    /// 点击顶部工具条返回按钮
    func didClickBackButton(in player: HTPlayer)
    /// 视频播放结束
    func didPlayToEnd(in player: HTPlayer)
    
    /// 视频完成缓冲回调
    func didPleyCompeteBuffer(in player: HTPlayer)
    
    /// 播放器播放进度变化
    func player(_ player: HTPlayer, playProgressChanged value: CGFloat)
    /// 播放器播放失败
    func player(_ player: HTPlayer, playFailed error: Error?)
    
    /// 播放器状态变化
    func playerObserveStatus(_ player: HTPlayer, playerState state: HTPlayerPlayState)
    
    /// 播放器卡顿检测及次数
    func playerKaDunCount(_ player: HTPlayer, count kaCount:Int)
    
    /// 点击锁屏
    func player(_ player: HTPlayer, clickPlayLockButton lock: Bool)
    
    /// 点击字幕设置
    func didClickSubtitleSettingButton(in player: HTPlayer)
    
    /// 点击分享
    func didClickShareButton(in player: HTPlayer)
    
    /// 点击下一集
    func didClickPleyNextEpisodeButton(in player: HTPlayer)
    
    /// 点击移除广告
    func didRemoveADButton(in player: HTPlayer)
    
    /// 字幕加载完成
    func player(_ player: HTPlayer, _ contentView: HTPlayerBaseContentView, subTitleLoadComplete parsedPayload: NSDictionary?)
    
    /// 当前时间回调
    func player(_ player: HTPlayer, _ currentDuration: TimeInterval)
    
    /// 当前字幕时间回调
    func playerCurrentSubTitleTime(_ player: HTPlayer, _ currentSubTitleDuration: TimeInterval)
 
    /// 横屏时右侧半瓶View
    func player(_ player: HTPlayer, _ contentView: HTPlayerBaseContentView, _ button: UIButton, _ index:Int) -> UIView
    
    /// 横屏时暂停广告View
    func playerPauseADView(_ player: HTPlayer, _ contentView: HTPlayerBaseContentView) -> UIView
    
    /// 横屏时顶部banner广告View
    func playerTopBannerView(_ player: HTPlayer, _ contentView: HTPlayerBaseContentView) -> UIView
    
    /// 点击全屏按钮
    func didClickFullButton(in player: HTPlayer, didClickFullButton isFull: Bool)
    
    /// 播放按钮点击
    func didClickPlayButton(in player: HTPlayer, didClickPlayButton isPlay: Bool)
    
    ///  屏幕将要旋转通知
    func deviceOrientationWillChange()
    
}

public extension HTPlayerDelegate {
    func didClickBackButton(in player: HTPlayer) {}
    func didPlayToEnd(in player: HTPlayer) {}
    func player(_ player: HTPlayer, playProgressChanged value: CGFloat) {}
    func player(_ player: HTPlayer, playFailed error: Error?) {}
}
