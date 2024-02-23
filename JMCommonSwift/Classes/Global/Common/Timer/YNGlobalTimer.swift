//
//  YNGlobalTimer.swift
//  YNCustomer
//
//  Created by James on 2021/6/17.
//

import Foundation

public final class YNGlobalTimer {
    public static let shared = YNGlobalTimer()

    public var isRunning: Bool { timer.fireDate == .distantFuture }

    /// 任务容器
    private typealias TaskDict = [String: Task]
    private var targetTasksDict = [String: TaskDict]()

    /// 线程
    private lazy var thread = Thread(target: self,
                                     selector: #selector(threadTask),
                                     object: nil)

    private lazy var semaphore = DispatchSemaphore(value: 1)

    /// 内部timer
    private lazy var timer = Timer(fireAt: .distantFuture,
                                   interval: interval,
                                   target: self,
                                   selector: #selector(timerTask),
                                   userInfo: nil,
                                   repeats: true)

    /// timer每次开始运行的总时间，毫秒，每次start都会清0
    private var duration: Millisecond = 0

    /// 内部定时器间隔时间，默认0.05秒
    private let interval = 0.05

    private init() {
        addTimerThread()
    }
}

// MARK: - Public

public extension YNGlobalTimer {
    typealias Handler = (_ currentDate: Date) -> Void

    /// 添加任务,添加一个任务后timer会自动开始
    ///
    /// - parameter target:      任务的目标对象，不指定就是YNGlobalTimer.shared，target销毁后，任务自动清除
    /// - parameter key:         任务的名字
    /// - parameter interval:    任务执行的间隔，单位秒，最小粒度是0.05，注意，比如0.0533会被修正为0.05
    /// - parameter queue:       任务执行的队列
    /// - parameter action:      具体任务
    class func addTask(on target: AnyObject = YNGlobalTimer.shared,
                       forKey key: String,
                       interval: TimeInterval,
                       queue: DispatchQueue = .main,
                       action: @escaping Handler) {
        shared.addTask(on: target,
                       forKey: key,
                       interval: interval,
                       queue: queue,
                       action: action)
    }

    /// 判断target对象上是否有key任务
    class func hasTask(on target: AnyObject? = nil,
                       forKey key: String) -> Bool {
        shared.hasTask(on: target, forKey: key)
    }

    /// 移除任务，没有任务的话timer会自动停止
    class func removeTask(on target: AnyObject? = nil,
                          forKey key: String? = nil) {
        shared.removeTask(on: target, forKey: key)
    }

    /// 暂停任务
    class func pauseTask(on target: AnyObject? = nil,
                         forKey key: String) {
        shared.pauseTask(on: target, forKey: key)
    }

    /// 恢复任务
    class func resumeTask(on target: AnyObject? = nil,
                          forKey key: String) {
        shared.resumeTask(on: target, forKey: key)
    }

    /// 移除所有任务，危险操作
    class func removeAllTasks() {
        shared.removeAllTask()
    }
}

// MARK: -  Thread & Timer

private extension YNGlobalTimer {
    func addTimerThread() {
        thread.start()
    }

    @objc func threadTask() {
        autoreleasepool {
            thread.name = "YNGlobalTimerThread"
            RunLoop.current.add(timer, forMode: .common)
            RunLoop.current.run()
        }
    }

    @objc func timerTask() {
        let currentDate = Date()
        var hasTask = false

        semaphore.wait()

        targetTasksDict.forEach { _, targetDict in
            targetDict.forEach { _, task in
                /// 目标对象释放掉，删除target上的所有任务
                if task.target == nil {
                    targetTasksDict.removeValue(forKey: task.targetName)
                } else {
                    /// 只有duration是任务执行间隔时间的倍数时，才执行该任务
                    if duration > 0,
                        !task.isPaused,
                        duration % task.interval == 0 {
                        let execute = {
                            if task.target != nil {
                                task.task(currentDate)
                            }
                        }

                        task.queue.async(execute: execute)
                    }
                    hasTask = true
                }
            }
        }

        duration += UInt(interval * 1000)

        /// 如果没有任务，暂停timer
        if !hasTask {
            pause()
        }

        semaphore.signal()
    }
}

// MARK: - Add & Remove Task

private extension YNGlobalTimer {
    typealias Millisecond = UInt

    class Task {
        weak var target: AnyObject?
        var isPaused = false
        var targetName: String

        var task: Handler
        var taskName: String

        var queue: DispatchQueue
        var interval: Millisecond // 任务的执行间隔，毫秒

        init(target: AnyObject,
             targetName: String,
             task: @escaping Handler,
             taskName: String,
             queue: DispatchQueue,
             interval: Millisecond) {
            self.target = target
            self.targetName = targetName
            self.task = task
            self.taskName = taskName
            self.queue = queue
            self.interval = interval
        }
    }

    func addTask(on target: AnyObject,
                 forKey key: String,
                 interval: TimeInterval,
                 queue: DispatchQueue = .main,
                 action: @escaping Handler) {
        let target = target
        let targetKey = _targetKey(for: target)

        /// 转换成对应的毫秒
        let intervalMS = UInt((floor(interval * 10.0) / 10) * 1000)

        let task = Task(target: target,
                        targetName: targetKey,
                        task: action,
                        taskName: key,
                        queue: queue,
                        interval: intervalMS)
        addTask(task)
    }

    func addTask(_ task: Task) {
        semaphore.wait()
        /// 值类型，注意
        if targetTasksDict[task.targetName] != nil {
            _ = self.targetTasksDict[task.targetName]?.updateValue(task, forKey: task.taskName)
        } else {
            let targetTasksDict = [task.taskName: task]
            self.targetTasksDict[task.targetName] = targetTasksDict
        }

        startIfNeeded()
        semaphore.signal()
    }

    func removeTask(on target: AnyObject? = nil, forKey key: String? = nil) {
        if target == nil, key == nil {
            return
        }

        let targetKey = _targetKey(for: target)

        semaphore.wait()
        if let taskKey = key {
            /// 删除target上指定任务
            _ = targetTasksDict[targetKey]?.removeValue(forKey: taskKey)
        } else {
            /// 删除target上的所有任务
            targetTasksDict.removeValue(forKey: targetKey)
        }
        pauseIfNeeded()

        semaphore.signal()
    }

    func removeAllTask() {
        semaphore.wait()

        targetTasksDict.removeAll()
        pause()

        semaphore.signal()
    }

    func task(on target: AnyObject?, forKey key: String) -> Task? {
        var task: Task?
        let targetKey = _targetKey(for: target)
        semaphore.wait()
        task = targetTasksDict[targetKey]?[key]
        semaphore.signal()

        return task
    }

    func hasTask(on target: AnyObject?, forKey key: String) -> Bool {
        return task(on: target, forKey: key) != nil
    }

    /// 暂停任务
    func pauseTask(on target: AnyObject?,
                   forKey key: String) {
        task(on: target, forKey: key)?.isPaused = true
    }

    /// 恢复任务
    func resumeTask(on target: AnyObject?,
                    forKey key: String) {
        task(on: target, forKey: key)?.isPaused = false
    }

    func _targetKey(for target: AnyObject?) -> String {
        return "\(target ?? self)"
    }
}

// MARK: - Start & Pause

private extension YNGlobalTimer {
    func startIfNeeded() {
        if !isRunning, targetTasksDict.values.count > 0 {
            start()
        }
    }

    func pauseIfNeeded() {
        if isRunning, targetTasksDict.values.count == 0 {
            pause()
        }
    }

    func start() {
        timer.fireDate = .init()
        duration = 0
    }

    func pause() {
        timer.fireDate = .distantFuture
    }
}
