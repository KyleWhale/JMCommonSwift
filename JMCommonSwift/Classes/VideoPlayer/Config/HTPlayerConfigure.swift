//
//  HTPlayerConfigure.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import AVFoundation
import UIKit

public struct HTPlayerConfigure {
    public struct HTPlayerColor {
        /// 顶部工具条背景颜色
        public var topToobar: UIColor
        /// 底部工具条背景颜色
        public var bottomToolbar: UIColor
        /// 进度条背景颜色
        public var progress: UIColor
        /// 缓冲条缓冲进度颜色
        public var progressBuffer: UIColor
        /// 进度条播放完成颜色
        public var progressFinished: UIColor
        /// 转子背景颜色
        public var loading: UIColor

        public init(topToobar: UIColor = UIColor.black.withAlphaComponent(0.6),
                    bottomToolbar: UIColor = UIColor.black.withAlphaComponent(0.6),
                    progress: UIColor = UIColor.white.withAlphaComponent(0.1),
                    progressBuffer: UIColor = UIColor.white.withAlphaComponent(0.5),
                    progressFinished: UIColor = UIColor.white,
                    loading: UIColor = UIColor.white)
        {
            self.topToobar = topToobar
            self.bottomToolbar = bottomToolbar
            self.progress = progress
            self.progressBuffer = progressBuffer
            self.progressFinished = progressFinished
            self.loading = loading
        }
    }

    public struct HTPlayerImage {
        /// 返回按钮图片
        public var back: UIImage?
        /// 更多按钮图片
        public var more: UIImage?
        /// 播放按钮图片
        public var play: UIImage?
        /// 暂停按钮图片
        public var pause: UIImage?
        /// 进度滑块图片
        public var slider: UIImage?
        /// 最大化按钮图片
        public var max: UIImage?
        /// 最小化按钮图片
        public var min: UIImage?

        public init(back: UIImage? = HTImageHelper.imageWithName(""),
                    more: UIImage? = HTImageHelper.imageWithName(""),
                    play: UIImage? = HTImageHelper.imageWithName(""),
                    pause: UIImage? = HTImageHelper.imageWithName(""),
                    slider: UIImage? = HTImageHelper.imageWithName("player_slider_thumb_image"),
                    max: UIImage? = HTImageHelper.imageWithName(""),
                    min: UIImage? = HTImageHelper.imageWithName(""))
        {
            self.back = back
            self.more = more
            self.play = play
            self.pause = pause
            self.slider = slider
            self.max = max
            self.min = min
        }
    }

    /// 顶部工具条隐藏风格
    public enum CLPlayerTopBarHiddenStyle {
        /// 小屏和全屏都不隐藏
        case never
        /// 小屏和全屏都隐藏
        case always
        /// 小屏隐藏，全屏不隐藏
        case onlySmall
    }

    /// 自动旋转类型
    public enum CLPlayerAutoRotateStyle {
        /// 禁止
        case none
        /// 只支持小屏
        case small
        /// 只支持全屏
        case fullScreen
        /// 全部
        case all
    }

    /// 手势控制类型
    public enum CLPlayerGestureInteraction {
        /// 禁止
        case none
        /// 只支持小屏
        case small
        /// 只支持全屏
        case fullScreen
        /// 全部
        case all
    }

    /// 是否隐藏更多面板
    public var isHiddenMorePanel = false
    /// 初始界面是否显示工具条
    public var isHiddenToolbarWhenStart = true
    /// 手势控制
    public var gestureInteraction = CLPlayerGestureInteraction.fullScreen
    /// 自动旋转类型
    public var rotateStyle = CLPlayerAutoRotateStyle.all
    /// 顶部工具条隐藏风格
    public var topBarHiddenStyle = CLPlayerTopBarHiddenStyle.onlySmall
    /// 工具条自动消失时间
    public var autoFadeOut = 5.0
    /// 默认拉伸方式
    public var videoGravity = AVLayerVideoGravity.resizeAspect
    /// 颜色
    public var color = HTPlayerColor()
    /// 图片
    public var image = HTPlayerImage()
}
