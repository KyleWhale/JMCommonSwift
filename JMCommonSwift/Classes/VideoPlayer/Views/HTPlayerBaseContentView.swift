//
//  HTPlayerBaseContentView.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation

public enum HTPlayerPlayState {
    case unknow
    case waiting
    case readyToPlay
    case playing
    case buffering
    case failed
    case pause
    case ended
}

extension HTPlayerBaseContentView {
    enum HTPlayerScreenState {
        case small
        case animating
        case fullScreen
    }

    enum HTPanDirection {
        case unknow
        case horizontal
        case leftVertical
        case rightVertical
    }
}

public class HTPlayerBaseContentView:UIView {
    
    var config: HTPlayerConfigure!
    
    /// 是否锁屏
    var lockScreen:Bool = false
    
    /// 是否已经去除了广告
    var removedAD:Bool = false
    
    var screenState: HTPlayerScreenState = .small {
        didSet {
            guard screenState != oldValue else { return }
            
            reloadScreenState()
        }
    }
    
    var playState: HTPlayerPlayState = .unknow {
        didSet {
            guard playState != oldValue else { return }
            print("playState:\(playState)")
            
            reloadPlayState()
        }
    }
    
    var totalDuration: TimeInterval = 0.0
    var currentDuration: TimeInterval = 0.0
    
    /// 字幕调整时间
    public var subTitleAdjustDuration: TimeInterval = 0.0
    
    /// 设置字幕调整时间+0.5
    public func setAddSubTitleAdjustDuration() {
        
        let duration = subTitleAdjustDuration + 0.5
        
        subTitleAdjustDuration = duration
    }
    
    /// 设置字幕调整时间-0.5
    public func setMinusSubTitleAdjustDuration() {
        
        let duration = subTitleAdjustDuration - 0.5
        
        subTitleAdjustDuration = duration
    }
    
    /// 重置设置字幕调整时间
    public func resetSubTitleAdjustDuration() {
 
        subTitleAdjustDuration = 0
    }
    
    /// 字幕状态 0: 无字幕 1:有字幕（未开启）2:有字幕（已开启）
    public var subTitleStatus:Int = 0
    
    /// 设置字幕状态 0: 无字幕 1:有字幕（未开启）2:有字幕（已开启）
    public func jm_setSubTitleStatus( _ status:Int) {
        
        subTitleStatus = status
        
        reloadSubTitleStatus()
    }
    
    /// 横屏时右侧View
    public lazy var panelRightView: UIView = {
        let view = UIView()

        return view
    }()
    
    /// 横屏时顶部广告bannner View
    public lazy var fullScreen_TopADBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 横屏时暂停广告 View
    public lazy var fullScreen_PauseADView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    /// 是否显示顶部广告banner视图
    public func jm_setHiddenFullScreenTopADBannerView( _ hidden:Bool) {
        
        fullScreen_TopADBannerView.isHidden = hidden
    }
    
    /// 是否显示暂停广告视图
    public func jm_setHiddenFullScreenPauseADView( _ hidden:Bool) {
        
        fullScreen_PauseADView.isHidden = hidden
    }
    
    /// 关闭横屏右侧视图
    public func jm_setHiddenFullScreenRightPanelView() {
        
        
    }
    
    func jm_setRemoveAD( removedAD:Bool) {
        
        self.removedAD = removedAD
        
        reloadUI()
    }
        
    
    weak var delegate: HTPlayerContentViewDelegate?
    
    var title: NSMutableAttributedString? {
        didSet {
            
            reloadUI()
        }
    }
    
    init(config: HTPlayerConfigure) {
        self.config = config
        super.init(frame: .zero)
        initUI()
        makeConstraints()
        updateConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
    }
    
    func makeConstraints() {
        
    }
    
    func updateConfig() {
        
    }
    
    // MARK: ---公共方法
    func animationLayout(safeAreaInsets: UIEdgeInsets, to screenState: HTPlayerScreenState) {
        
    }
    
    func setProgress(_ progress: Float, animated: Bool) {
        
    }

    func setSliderProgress(_ progress: Float, animated: Bool) {
        
    }

    func setTotalDuration(_ totalDuration: TimeInterval) {
        
    }

    func setCurrentDuration(_ currentDuration: TimeInterval) {
        
    }
    
    func reloadScreenState() {
        
    }
    
    func reloadPlayState() {
        
        
    }
    
    func reloadUI() {
        
        
    }
    
    /// 更新字幕状态
    func reloadSubTitleStatus() {
        
        
    }
    
    func hidden_MorePanView() {
        
        
    }
    
    func setSelectEpisodeButtonTitle( _ title:String) {
        
    }
    
}
