//
//  HTGCDTimer.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import UIKit

public class HTGCDTimer: NSObject {
    public typealias actionBlock = (NSInteger) -> Void
    /// 执行时间
    var interval: TimeInterval!
    /// 延迟时间
    var delaySecs: TimeInterval!
    /// 队列
    var serialQueue: DispatchQueue!
    /// 是否重复
    var repeats: Bool = true
    /// 响应
    var action: actionBlock?
    /// 定时器
    var timer: DispatchSourceTimer!
    /// 是否正在运行
    var isRuning: Bool = false
    /// 响应次数
    var actionTimes: NSInteger = 0

    /// 创建定时器
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - delaySecs: 第一次执行延迟时间，默认为0
    ///   - queue: 定时器调用的队列，默认主队列
    ///   - repeats: 是否重复执行，默认true
    ///   - action: 响应
    public init(interval: TimeInterval, delaySecs: TimeInterval = 0, queue: DispatchQueue = .main, repeats: Bool = true, action: actionBlock?) {
        super.init()
        self.interval = interval
        self.delaySecs = delaySecs
        self.repeats = repeats
        serialQueue = queue
        self.action = action
        timer = DispatchSource.makeTimerSource(queue: serialQueue)
    }

    /// 替换旧响应
    func replaceOldAction(action: actionBlock?) {
        guard let action = action else {
            return
        }
        self.action = action
    }

    /// 执行一次定时器响应
    func responseOnce() {
        actionTimes += 1
        isRuning = true
        action?(actionTimes)
        isRuning = false
    }

    deinit {
        cancel()
    }
}

extension HTGCDTimer {
    /// 开始定时器
    public func start() {
        timer.schedule(deadline: .now() + delaySecs, repeating: interval)
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.actionTimes += 1
            strongSelf.action?(strongSelf.actionTimes)
            if !strongSelf.repeats {
                strongSelf.cancel()
                strongSelf.action = nil
            }
        }
        resume()
    }

    /// 暂停
    public func suspend() {
        if isRuning {
            timer.suspend()
            isRuning = false
        }
    }

    /// 恢复定时器
    public func resume() {
        if !isRuning {
            timer.resume()
            isRuning = true
        }
    }

    /// 取消定时器
    public func cancel() {
        if !isRuning {
            resume()
        }
        timer.cancel()
    }
}
