//
//  HTPlayer.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import AVFoundation
import SnapKit
import UIKit

public enum HTWaitReadyToPlayState {
    case nomal
    case pause
    case play
}

public class HTPlayer: UIView {
    
    
    public init(frame: CGRect = .zero, config: ((inout HTPlayerConfigure) -> Void)? = nil) {
        super.init(frame: frame)
        config?(&self.config)
        initUI()
        makeConstraints()
        //(layer as? AVPlayerLayer)?.videoGravity = self.config.videoGravity
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        print("CLPlayer deinit")
    }
    
    private(set) lazy var contentView: HTPlayerContentView = {
        let view = HTPlayerContentView(config: config)
        view.delegate = self
        
        return view
    }()
    
    private let keyWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter { $0.isKeyWindow }.last
        } else {
            return UIApplication.shared.keyWindow
        }
    }()
    
    private var waitReadyToPlayState: HTWaitReadyToPlayState = .nomal
    
    private var sliderTimer: HTGCDTimer?
    
    private var bufferTimer: HTGCDTimer?
    
    private var config = HTPlayerConfigure()
    
    private var animationTransitioning: HTAnimationTransitioning?
    
    private var fullScreenController: HTFullScreenController?
    
    private var statusObserve: NSKeyValueObservation?
    
    private var loadedTimeRangesObserve: NSKeyValueObservation?
    
    private var playbackBufferEmptyObserve: NSKeyValueObservation?
    
    private var isUserPause: Bool = false
    
    private var isEnterBackground: Bool = false
    
    private var player:HTAVPlayer?
    
    public private(set) var totalDuration: TimeInterval = .zero {
        didSet {
            //guard totalDuration != oldValue else { return }
            contentView.setTotalDuration(totalDuration)
        }
    }
    
    public private(set) var currentDuration: TimeInterval = .zero {
        didSet {
            guard currentDuration != oldValue else { return }
            contentView.setCurrentDuration(min(currentDuration, totalDuration))
            
            delegate?.player(self, min(currentDuration, totalDuration))
            
            delegate?.playerCurrentSubTitleTime(self, min(currentDuration, totalDuration) + self.contentView.subTitleAdjustDuration)
        }
    }
    
    public private(set) var playbackProgress: CGFloat = .zero {
        didSet {
            guard playbackProgress != oldValue else { return }
            contentView.setSliderProgress(Float(playbackProgress), animated: false)
            let oldIntValue = Int(oldValue * 100)
            let intValue = Int(playbackProgress * 100)
            if intValue != oldIntValue {
                DispatchQueue.main.async {
                    self.delegate?.player(self, playProgressChanged: CGFloat(intValue) / 100)
                }
            }
        }
    }
    
    public private(set) var rate: Float = 1.0 {
        didSet {
            guard rate != oldValue else { return }
            play()
        }
    }
    
    public var isFullScreen: Bool {
        return contentView.screenState == .fullScreen
    }
    
    public var isPlaying: Bool {
        return contentView.playState == .playing
    }
    
    public var isBuffering: Bool {
        return contentView.playState == .buffering
    }
    
    public var isFailed: Bool {
        return contentView.playState == .failed
    }
    
    public var isPaused: Bool {
        return contentView.playState == .pause
    }
    
    public var isEnded: Bool {
        return contentView.playState == .ended
    }
    
    public var isReadyToPlay: Bool {
        return contentView.playState == .readyToPlay
    }
    
    public var title: NSMutableAttributedString? {
        didSet {
            guard let title = title else { return }
            contentView.title = title
        }
    }
    
    /// 字幕状态 0: 无字幕 1:有字幕（未开启）2:有字幕（已开启）
    public var subTitleStatus:Int = 0
    
    /// 设置字幕状态 0: 无字幕 1:有字幕（未开启）2:有字幕（已开启）
    public func jm_setSubTitleStatus( _ status:Int) {
        
        subTitleStatus = status
        
        contentView.jm_setSubTitleStatus(status)
    }
    
    public func jm_setSelectEpisodeButtonTitle( _ title:String) {
        
        contentView.setSelectEpisodeButtonTitle(title)
    }
    
    public func jm_setScreenMirrorCapturedLockScreen( _ lock:Bool) {
        
        contentView.capturedLockScreen = lock
    }
    
    public var url: URL? {
        didSet {
            guard let url = url else { return }
            stop()
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playback)
                try session.setActive(true)
            } catch {
                print("set session error:\(error)")
            }
            
            /*
             playerItem = AVPlayerItem(asset: .init(url: url))
             player = AVPlayer(playerItem: playerItem)
             (layer as? AVPlayerLayer)?.player = player
             */
            player = HTAVPlayer(url: url)
            player?.delegate = self
            
            if let player = player {
                
                player.frame = self.bounds
                self.addSubview(player)
                
                self.sendSubviewToBack(player)
            }
            
        }
    }
    
    public override func layoutSubviews() {
        
        if let player = player {
            
            player.frame = self.bounds
        }
    }
    
    public weak var placeholder: UIView? {
        didSet {
            contentView.placeholderView = placeholder
        }
    }
    
    public weak var delegate: HTPlayerDelegate?
    
    /// 设置字幕调整时间+0.5
    public func setAddSubTitleAdjustDuration() {
        
        self.contentView.setAddSubTitleAdjustDuration()
    }
    
    /// 设置字幕调整时间-0.5
    public func setMinusSubTitleAdjustDuration() {
        
        self.contentView.setMinusSubTitleAdjustDuration()
    }
    
    /// 重置设置字幕调整时间
    public func resetSubTitleAdjustDuration() {
        
        self.contentView.resetSubTitleAdjustDuration()
    }
    
    public func exitFullScreen( _ completeBlock: @escaping ()->Void) {
        
        dismiss()
        
        UIView.animate(withDuration: 0.5) {
            
            completeBlock()
        }
    }
    
    /// 关闭横屏右侧视图
    public func jm_setHiddenFullScreenRightPanelView() {
        
        self.contentView.jm_setHiddenFullScreenRightPanelView()
    }
    
    /// 是否显示顶部广告banner视图
    public func jm_setHiddenFullScreenTopADBannerView( _ hidden:Bool) {
        
        self.contentView.jm_setHiddenFullScreenTopADBannerView(hidden)
    }
    
    /// 是否显示暂停广告视图
    public func jm_setHiddenFullScreenPauseADView( _ hidden:Bool) {
        
        self.contentView.jm_setHiddenFullScreenPauseADView(hidden)
    }
    
    public func jm_setADView() {
        
        jm_setFullScreenPauseADView()
        jm_setFullScreenTopBannerADView()
    }
    
    public func jm_setRemoveAD( removedAD:Bool) {
        
        self.contentView.jm_setRemoveAD(removedAD: removedAD)
    }
    
    /// 设置播放时间
    public func jm_setCurrentDuration( _ currentDuration: TimeInterval ) {
        
        self.currentDuration = currentDuration
        
        player?.seekTo(to: currentDuration)
    }
}

// MARK: ---override

//public extension HTPlayer {
//    override class var layerClass: AnyClass {
//        return AVPlayerLayer.classForCoder()
//    }
//}

// MARK: ---布局

private extension HTPlayer {
    func initUI() {
        backgroundColor = .black
        addSubview(contentView)
//        NotificationCenter.default.addObserver(self, selector: #selector(jm_appDidEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterPlayground), name: UIApplication.didBecomeActiveNotification, object: nil)
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }

    func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
}

public extension HTPlayer {
    
    func jm_loadSTRFile(fileFromRemote filePath: URL, encoding: String.Encoding = .utf8) {
        
        contentView.jm_loadSTRFile(fileFromRemote: filePath,encoding: encoding)
    }
    
    func jm_loadSTRData(fileData data:Data?) {
        
        contentView.jm_loadSTRData(fileData: data)
    }
}

// MARK: ---objc

@objc private extension HTPlayer {
    func didPlaybackEnds() {
        currentDuration = totalDuration
        playbackProgress = 1.0
        contentView.playState = .ended
        sliderTimer?.suspend()
        DispatchQueue.main.async {
            self.delegate?.didPlayToEnd(in: self)
        }
    }

    func deviceOrientationDidChange() {
        guard !contentView.lockScreen else { return }
        guard !contentView.capturedLockScreen else { return }
        guard config.rotateStyle != .none else { return }
        if config.rotateStyle == .small, isFullScreen { return }
        if config.rotateStyle == .fullScreen, !isFullScreen { return }
 
        if let vc = yn_topVC {
            /// 如果正在加载广告时，则禁止屏幕旋转
            
            if let viewController = self.superview?.viewController() {
                
                let className = viewController.yn_className
           
                if vc.yn_className != className {
                    
                    return;
                }
            }
            
            if vc.yn_className == "ALAppLovinVideoViewController" {
                
                return;
            }
        }

        self.delegate?.deviceOrientationWillChange()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
            
            DispatchQueue.main.async {
                
                var var_isPortrait:Bool = true
                
                switch UIDevice.current.orientation {
                case .portrait:
                    self.dismiss()
                    
                    
                    
                case .landscapeLeft:
                    self.presentWithOrientation(.left)
                    
                    var_isPortrait = false
                case .landscapeRight:
                    self.presentWithOrientation(.right)
                    
                    var_isPortrait = false
                default:
                    
                    return
                    
                    break
                }
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.36) {
                    
                    DispatchQueue.main.async {

                        self.delegate?.didClickFullButton(in: self, didClickFullButton: var_isPortrait)
                        
                        self.checkPlayStateWhenRotatingScreen()
                    }
                }
                
            }
        }
        
        
    }

    func jm_appDidEnterBackground() {
        isEnterBackground = true
        pause()
    }

    func appDidEnterPlayground() {
        isEnterBackground = false
        guard contentView.playState != .ended else { return }
        play()
    }
}

// MARK: ---observe

extension UIView {
    func viewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}

//private extension HTPlayer {
//
//}

private extension HTPlayer {
//    func availableDuration() -> TimeInterval? {
//        guard let timeRange = playerItem?.loadedTimeRanges.first?.timeRangeValue else { return nil }
//        let startSeconds = CMTimeGetSeconds(timeRange.start)
//        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
//        return .init(startSeconds + durationSeconds)
//    }

    func bufferingSomeSecond() {
        //guard playerItem?.status == .readyToPlay else { return }
        guard contentView.playState != .failed else { return }

        player?.pause()
        sliderTimer?.suspend()
        bufferTimer?.cancel()

        contentView.playState = .buffering
        bufferTimer = HTGCDTimer(interval: 0, delaySecs: 0.25, repeats: false, action: { [weak self] _ in
            /*
            guard let playerItem = self?.playerItem else { return }
            if playerItem.isPlaybackLikelyToKeepUp {
                self?.play()
            } else {
                self?.bufferingSomeSecond()
            }*/
            
            if let self = self {
                
                if let player = self.player {
                    
                    if player.isPlaybackLikelyToKeepUp {
                        
                        self.play()
                        
                        self.delegate?.didPleyCompeteBuffer(in: self)
                    }
                    else {
                        self.bufferingSomeSecond()
                    }
                }
            }

        })
        bufferTimer?.start()
    }
    
    func checkPlayStateWhenRotatingScreen() {
        
        if let player = self.player {
            
            if player.isPlaybackLikelyToKeepUp {
                
                self.play()
                
                self.delegate?.didPleyCompeteBuffer(in: self)
            }
            else {
                self.bufferingSomeSecond()
            }
        }
    }

    func sliderTimerAction() {
        //guard let playerItem = playerItem else { return }
        //guard playerItem.duration.timescale != .zero else { return }

        //currentDuration = CMTimeGetSeconds(playerItem.currentTime())
        
        if let player = self.player {
            
            currentDuration = player.getCurrentTime()
            playbackProgress = currentDuration / totalDuration
        }

    }
    
    func observeStatusAction() {
 
        if player?.playStatus == .readyToPlay {
            contentView.playState = .readyToPlay
            
            totalDuration = player?.totalDuration ?? 0.0

            sliderTimer = HTGCDTimer(interval: 0.1) { [weak self] _ in
                self?.sliderTimerAction()
            }
            sliderTimer?.start()

            switch waitReadyToPlayState {
            case .nomal:
                break
            case .pause:
                pause()
            case .play:
                play()
            }
        } else if player?.playStatus == .failed {
            contentView.playState = .failed
            
        }
    }
}

// MARK: ---Screen

private extension HTPlayer {
    func dismiss() {
        guard contentView.screenState == .fullScreen else { return }
        guard let controller = fullScreenController else { return }
        contentView.screenState = .animating
        
        self.contentView.hidden_MorePanView()
        
        controller.dismiss(animated: true, completion: {
            self.contentView.screenState = .small
        })
        fullScreenController = nil
        UIViewController.attemptRotationToDeviceOrientation()
    }

    func presentWithOrientation(_ orientation: HTAnimationTransitioning.HTAnimationOrientation) {
        guard superview != nil else { return }
        guard fullScreenController == nil else { return }
        guard contentView.screenState == .small else { return }
        //guard let rootViewController = keyWindow?.rootViewController else { return }
        guard let rootViewController = yn_topVC else { return }
        contentView.screenState = .animating

        animationTransitioning = HTAnimationTransitioning(playView: self, orientation: orientation)

        fullScreenController = orientation == .right ? HTFullScreenLeftController() : HTFullScreenRightController()
        fullScreenController?.transitioningDelegate = self
        fullScreenController?.modalPresentationStyle = .fullScreen
        
        rootViewController.present(fullScreenController!, animated: true, completion: {
            self.contentView.screenState = .fullScreen
            UIViewController.attemptRotationToDeviceOrientation()
        })
    }
}

// MARK: ---公共方法

public extension HTPlayer {
    func play() {
        guard !isEnterBackground else { return }
        guard !isUserPause else { return }
        guard !contentView.capturedLockScreen else { return }
        //guard let playerItem = playerItem else { return }
        /*
        guard playerItem.status == .readyToPlay else {
            contentView.playState = .waiting
            waitReadyToPlayState = .play
            return
        }
        guard playerItem.isPlaybackLikelyToKeepUp else {
            bufferingSomeSecond()
            return
        }*/
        
        if player?.playStatus != .readyToPlay {
            
            contentView.playState = .waiting
            waitReadyToPlayState = .play
            return
        }
        
        if let player = player {
            
            if !player.isPlaybackLikelyToKeepUp {
                
                bufferingSomeSecond()
                
                return
            }
        }
        
        if contentView.playState == .ended {
            //player?.seek(to: CMTimeMake(value: 0, timescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
            player?.seekTo(to: 0)
        }
        contentView.playState = .playing
        player?.play()
        player?.rate = rate
        sliderTimer?.resume()
        waitReadyToPlayState = .nomal
    }

    func pause() {
//        guard playerItem?.status == .readyToPlay else {
//            waitReadyToPlayState = .pause
//            return
//        }
        
        if player?.playStatus != .readyToPlay {
            
            waitReadyToPlayState = .pause
            return
        }
        
        contentView.playState = .pause
        player?.pause()
        sliderTimer?.suspend()
        bufferTimer?.cancel()
        waitReadyToPlayState = .nomal
    }

    func stop() {
        statusObserve?.invalidate()
        loadedTimeRangesObserve?.invalidate()
        playbackBufferEmptyObserve?.invalidate()

        statusObserve = nil
        loadedTimeRangesObserve = nil
        playbackBufferEmptyObserve = nil

        //playerItem = nil
        
        if let player = player {
            
            player.removeFromSuperview()
        }
        
        player = nil

        isUserPause = false

        waitReadyToPlayState = .nomal

        contentView.playState = .unknow
        contentView.setProgress(0, animated: false)
        contentView.setSliderProgress(0, animated: false)
        contentView.setTotalDuration(0)
        contentView.setCurrentDuration(0)
        sliderTimer?.cancel()
    }
}

// MARK: ---UIViewControllerTransitioningDelegate

extension HTPlayer: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning?.animationType = .present
        return animationTransitioning
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransitioning?.animationType = .dismiss
        return animationTransitioning
    }
}

extension UIView {
    
    // 移除所有子视图
    func htPlayer_removeAllSubviews() {
        for v in self.subviews {
            if v.isKind(of: UIView.self) {
                v.removeFromSuperview()
            }
        }
    }
    
}

// MARK: ---HTPlayerContentViewDelegate

extension HTPlayer: HTPlayerContentViewDelegate {
    
    func jm_didClickPlayLockButton(in contentView: HTPlayerBaseContentView, lock isLock: Bool) {
        DispatchQueue.main.async {
            self.delegate?.player(self, clickPlayLockButton: isLock)
        }
    }
    
    func contentView(_ contentView: HTPlayerBaseContentView, didClickPlayButton isPlay: Bool) {
        isUserPause = isPlay
        isPlay ? pause() : play()
        
        DispatchQueue.main.async {
            self.delegate?.didClickPlayButton(in: self, didClickPlayButton: isPlay)
        }
    }

    func contentView(_ contentView: HTPlayerBaseContentView, didClickFullButton isFull: Bool) {
        isFull ? dismiss() : presentWithOrientation(.fullRight)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.26) {
            
            DispatchQueue.main.async {
                self.delegate?.didClickFullButton(in: self, didClickFullButton: isFull)
            }
        }

    }

    func contentView(_ contentView: HTPlayerBaseContentView, didChangeRate rate: Float) {
        self.rate = rate
    }

    func contentView(_ contentView: HTPlayerBaseContentView, didChangeVideoGravity videoGravity: AVLayerVideoGravity) {
        (layer as? AVPlayerLayer)?.videoGravity = videoGravity
    }

    func contentView(_ contentView: HTPlayerBaseContentView, sliderTouchBegan slider: HTSlider) {
        pause()
    }

    func contentView(_ contentView: HTPlayerBaseContentView, sliderValueChanged slider: HTSlider) {
        currentDuration = totalDuration * TimeInterval(slider.value)
        //let dragedCMTime = CMTimeMake(value: Int64(ceil(currentDuration)), timescale: 1)
        //player?.seek(to: dragedCMTime, toleranceBefore: .zero, toleranceAfter: .zero)
        player?.seekTo(to: currentDuration)
    }

    func contentView(_ contentView: HTPlayerBaseContentView, sliderTouchEnded slider: HTSlider) {
        //guard let playerItem = playerItem else { return }
        guard let player = player else { return }
        
        if slider.value == 1 {
            didPlaybackEnds()
        } else if player.isPlaybackLikelyToKeepUp {
            play()
        } else {
            bufferingSomeSecond()
        }
    }

    func jm_didClickFailButton(in _: HTPlayerBaseContentView) {
        guard let url = url else { return }
        self.url = url
    }

    func jm_didClickBackButton(in contentView: HTPlayerBaseContentView) {
        /*
        guard contentView.screenState == .fullScreen else { return }
        dismiss()
        DispatchQueue.main.async {
            self.delegate?.didClickBackButton(in: self)
        }*/
        
        if contentView.screenState == .fullScreen {
            dismiss()
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.26) {
                
                DispatchQueue.main.async {
                    self.delegate?.didClickFullButton(in: self, didClickFullButton: true)
                }
            }
        }
        else {
            self.delegate?.didClickBackButton(in: self)
        }
    }
    
    func jm_didClickPlayBackUpButton(in contentView: HTPlayerBaseContentView) {
        
        /// 后退10秒
        if let player = self.player {
            
            currentDuration = player.getCurrentTime()
            
            var duration = currentDuration - 10
            
            if duration < 0 {
                
                duration = 0
            }
            
            player.seekTo(to: duration)
        }
        
    }
    
    func jm_didClickPlayAdvanceButton(in contentView: HTPlayerBaseContentView) {
        /// 前进10秒
        if let player = self.player {
            
            currentDuration = player.getCurrentTime()
            
            var duration = currentDuration + 10
            
            if duration > totalDuration {
                
                duration = totalDuration
            }
            
            player.seekTo(to: duration)
        }
    }
    
    func jm_didClickPlayRemoveADButton(in contentView: HTPlayerBaseContentView) {
        
        delegate?.didRemoveADButton(in: self)
    }
    
    func jm_didClickPlayNextEpisodeButton(in contentView: HTPlayerBaseContentView) {
        
        delegate?.didClickPleyNextEpisodeButton(in: self)
    }
    
    func jm_didClickPlaySelectEpisodeButton(in contentView: HTPlayerBaseContentView, button buttonView: UIButton, index indexForButton: Int) {
        
        if let view = delegate?.player(self, contentView, buttonView, indexForButton) {
            
            self.contentView.panelRightView.htPlayer_removeAllSubviews()
            self.contentView.panelRightView.addSubview(view)
            view.snp.remakeConstraints { make in
                make.edges.equalTo(0)
            }
        }
        
        
    }
    
    func jm_setFullScreenPauseADView () {
        
        if let view = delegate?.playerPauseADView(self, self.contentView) {
            
            self.contentView.fullScreen_PauseADView.htPlayer_removeAllSubviews()
            self.contentView.fullScreen_PauseADView.addSubview(view)
            view.snp.remakeConstraints { make in
                make.edges.equalTo(0)
            }
        }
    }
    
    func jm_setFullScreenTopBannerADView () {
        
        if let view = delegate?.playerTopBannerView(self, self.contentView) {
            
            self.contentView.fullScreen_TopADBannerView.htPlayer_removeAllSubviews()
            self.contentView.fullScreen_TopADBannerView.addSubview(view)
            view.snp.remakeConstraints { make in
                make.edges.equalTo(0)
            }
        }
    }

    
    func jm_didClickShareButton(in contentView: HTPlayerBaseContentView) {
        
        delegate?.didClickShareButton(in: self)
    }
    
    func jm_didClickScreenButton(in contentView: HTPlayerBaseContentView) {
        
        delegate?.didClickScreenButton(in: self)
    }
    
    func jm_didClickSubTitleSettingButton(in contentView: HTPlayerBaseContentView, fullState isFullState: Bool, button buttonView: UIButton, index indexForButton: Int) {
        
        /// 全屏状态
        if isFullState {
            
            if let view = delegate?.player(self, contentView, buttonView, indexForButton) {
                
                self.contentView.panelRightView.htPlayer_removeAllSubviews()
                self.contentView.panelRightView.addSubview(view)
                view.snp.remakeConstraints { make in
                    make.edges.equalTo(0)
                }
            }
        }
        else {
            
            /// 竖屏
            delegate?.didClickSubtitleSettingButton(in: self)
        }
        
    }

    
    // 字幕加载完成
    func jm_contentView(_ contentView: HTPlayerBaseContentView, subTitleLoadComplete parsedPayload: NSDictionary?) {
        
        delegate?.player(self, contentView, subTitleLoadComplete: parsedPayload)
    }
    
    func jm_didClickFastForward(_ contentView: HTPlayerBaseContentView, fastForwardTime timeSecond: Double) {
        
        if let player = self.player {
            
            player.seekTo(to: timeSecond)
        }
    }
}

// MARK: ---HTPlayerBaseDelegate
extension HTPlayer:HTPlayerBaseDelegate {
    
    public func didPlaybackEnds(in player: HTPlayerBaseView) {
        
        didPlaybackEnds()
    }
    
    public func bufferingSomeSecond(in player: HTPlayerBaseView) {
        
        bufferingSomeSecond()
    }
    
    public func sliderTimerAction(in player: HTPlayerBaseView) {
        
        sliderTimerAction()
    }
    
    public func setProgress(in player: HTPlayerBaseView, progress: Double, animation: Bool) {
        
        contentView.setProgress(Float(progress), animated: animation)
    }
    
    public func observeStatusAction(in player: HTPlayerBaseView) {
        
        observeStatusAction()
        
        delegate?.playerObserveStatus(self, playerState: self.contentView.playState)
    }
    
    public func didKaDunCount(in player: HTPlayerBaseView, count kaCount: Int) {
        
        delegate?.playerKaDunCount(self, count: kaCount)
    }
}
