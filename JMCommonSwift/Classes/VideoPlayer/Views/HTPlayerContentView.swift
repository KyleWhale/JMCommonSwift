//
//  HTPlayerContentView.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import AVFoundation
import MediaPlayer
import SnapKit
import UIKit

//是否是iPad
public let HTConstIsiPad:Bool  = UIDevice.current.userInterfaceIdiom == .pad

class HTPlayerContentView: HTPlayerBaseContentView {
    
    var parsedPayload: NSDictionary?
    
    var parsedPayloadArray: [NSDictionary]?
    
    var panDirectionBegainCurrentDuration:Double = 0.0
    
    var var_subtitlesParseObject:HTSubtitles = HTSubtitles()
    
    private lazy var placeholderStackView: UIStackView = {
        let view = UIStackView()
        view.isHidden = true
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var topToolView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var topToolGradualView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var bottomToolView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bottomToolGradualView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var bottomContentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var bottomSafeView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var loadingView: HTRotateAnimationView = {
        let view = HTRotateAnimationView(frame: .init(x: 0, y: 0, width: 40, height: 40))
        view.startAnimation()
        return view
    }()

    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_backButtonAction), for: .touchUpInside)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.init(name: "Helvetica-Helvetica", size: 14.fit) ?? UIFont.systemFont(ofSize: 14.fit)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 1.0
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var moreButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_moreButtonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var CCSubtitleButton: UIButton = {
        let view = UIButton()
        view.isEnabled = false
        view.addTarget(self, action: #selector(jm_CCSubTitleButtonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var shareButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_shareButtonAction), for: .touchUpInside)
        return view
    }()
        
    private lazy var playCenterButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.addTarget(self, action: #selector(jm_playCenterButtonAction(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var playButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_playButtonAction(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var fullButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_fullButtonAction(_:)), for: .touchUpInside)
        return view
    }()

    private lazy var currentDurationLabel: UILabel = {
        let view = UILabel()
        view.text = "00:00"
        view.font = UIFont.init(name: "Helvetica-Helvetica", size: 14.fit) ?? UIFont.systemFont(ofSize: 14.fit)
        view.textColor = .white
        view.textAlignment = .center
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private lazy var totalDurationLabel: UILabel = {
        let view = UILabel()
        view.text = "00:00"
        view.font = UIFont.init(name: "Helvetica-Helvetica", size: 14.fit) ?? UIFont.systemFont(ofSize: 14.fit)
        view.textColor = .white
        view.textAlignment = .center
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white.withAlphaComponent(0.35)
        view.progressTintColor = .white.withAlphaComponent(0.5)
        return view
    }()

    private lazy var sliderView: HTSlider = {
        let view = HTSlider()
        view.isUserInteractionEnabled = false
        view.maximumValue = 1
        view.minimumValue = 0
        view.minimumTrackTintColor = YNHexString("#EC673D")
        view.addTarget(self, action: #selector(jm_progressSliderTouchBegan(_:)), for: .touchDown)
        view.addTarget(self, action: #selector(jm_progressSliderValueChanged(_:)), for: .valueChanged)
        view.addTarget(self, action: #selector(jm_progressSliderTouchEnded(_:)), for: [.touchUpInside, .touchCancel, .touchUpOutside])
        return view
    }()
    
    /// 后退按钮
    private lazy var playBackUpButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_playBackUpAction(_:)), for: .touchUpInside)
        return view
    }()
    
    /// 前进按钮
    private lazy var playAdvanceButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_playAdvanceAction(_:)), for: .touchUpInside)
        return view
    }()
    
    /// 锁屏按钮
    private lazy var playLockButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_playLockAction(_:)), for: .touchUpInside)
        return view
    }()
    
    /// 去除广告按钮
    private lazy var removeADButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_removeADAction(_:)), for: .touchUpInside)
        return view
    }()
    
    /// 下一集按钮
    private lazy var nextEpisodeButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(jm_playNextEpisodeAction(_:)), for: .touchUpInside)
        return view
    }()
    
    /// 选集按钮
    private lazy var selectEpisodeButton: UIButton = {
        let view = UIButton()
        view.setTitle("Episode", for: .normal)
        view.titleLabel?.font = UIFont.init(name: "Helvetica-Helvetica", size: 12.fit) ?? UIFont.systemFont(ofSize: 12.fit)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.textAlignment = .right
        view.addTarget(self, action: #selector(jm_selectEpisodeAction(_:)), for: .touchUpInside)
        view.contentHorizontalAlignment = .right
        return view
    }()

    private lazy var failButton: UIButton = {
        let view = UIButton()
        view.isHidden = true
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitle("加载失败,点击重试", for: .normal)
        view.setTitle("加载失败,点击重试", for: .selected)
        view.setTitle("加载失败,点击重试", for: .highlighted)
        view.setTitleColor(.white, for: .normal)
        view.setTitleColor(.white, for: .selected)
        view.setTitleColor(.white, for: .highlighted)
        view.addTarget(self, action: #selector(jm_failButtonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var fastForwardView: HTPleyFastForwardView = {
        let view = HTPleyFastForwardView()
        view.isHidden = true
        return view
    }()
    

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(jm_tapAction))
        gesture.delegate = self
        return gesture
    }()

    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(jm_panDirection(_:)))
        gesture.maximumNumberOfTouches = 1
        gesture.delaysTouchesBegan = true
        gesture.delaysTouchesEnded = true
        gesture.cancelsTouchesInView = true
        gesture.delegate = self
        return gesture
    }()

    private lazy var volumeSlider: UISlider? = {
        let view = MPVolumeView()
        return view.subviews.first(where: { $0 is UISlider }) as? UISlider
    }()
    
    private lazy var brightnessSliderView: HTBrightnessSliderView = {
        let view = HTBrightnessSliderView()
        view.isHidden = true
        return view
    }()

    private var isShowMorePanel: Bool = false {
        didSet {
            guard isShowMorePanel != oldValue else { return }
            if isShowMorePanel {
                jm_hiddenToolView()
                panelRightView.snp.updateConstraints { make in
                    make.right.equalTo(0)
                }
            } else {
                if screenState == .fullScreen {
                    jm_showToolView()
                }
                panelRightView.snp.updateConstraints { make in
                    make.right.equalTo(morePanelWidth)
                }
            }
            UIView.animate(withDuration: 0.25) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    

    private var isHiddenToolView: Bool = true

    private var panDirection: HTPanDirection = .unknow

    private var autoFadeOutTimer: HTGCDTimer?

    private var rates: [Float] = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]

    private var videoGravity: [(name: String, mode: AVLayerVideoGravity)] = [("适应", .resizeAspect), ("拉伸", .resizeAspectFill), ("填充", .resize)]

    private let morePanelWidth: CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.382

    weak var placeholderView: UIView? {
        didSet {
            guard placeholderView != oldValue else { return }
            placeholderStackView.isHidden = placeholderView == nil
            if let newView = placeholderView {
                placeholderStackView.addArrangedSubview(newView)
            }
            guard let oldView = oldValue else { return }
            placeholderStackView.removeArrangedSubview(oldView)
        }
    }

    var currentRate: Float = 1.0 {
        didSet {
            guard currentRate != oldValue else { return }
            //selectEpisodeView.reloadData()
            delegate?.contentView(self, didChangeRate: currentRate)
        }
    }

    var currentVideoGravity: AVLayerVideoGravity = .resizeAspectFill {
        didSet {
            guard currentVideoGravity != oldValue else { return }
            //selectEpisodeView.reloadData()
            delegate?.contentView(self, didChangeVideoGravity: currentVideoGravity)
        }
    }
    
    override func initUI() {
       clipsToBounds = true
       autoresizesSubviews = true
       isUserInteractionEnabled = true

       addSubview(subTitleLabel)
       addSubview(topToolView)
       addSubview(bottomToolView)
       addSubview(loadingView)
       addSubview(playCenterButton)
       addSubview(playBackUpButton)
       addSubview(playAdvanceButton)
       addSubview(playLockButton)
       addSubview(removeADButton)
       addSubview(fastForwardView)
        
       topToolView.addSubview(topToolGradualView)
       topToolView.addSubview(backButton)
       topToolView.addSubview(titleLabel)
       //topToolView.addSubview(moreButton)
       topToolView.addSubview(CCSubtitleButton)
       topToolView.addSubview(shareButton)
       bottomToolView.addSubview(bottomToolGradualView)
       bottomToolView.addSubview(bottomContentView)
       bottomToolView.addSubview(bottomSafeView)
       bottomContentView.addSubview(playButton)
        
       bottomContentView.addSubview(fullButton)
       bottomContentView.addSubview(currentDurationLabel)
       bottomContentView.addSubview(totalDurationLabel)
       bottomContentView.addSubview(progressView)
       bottomContentView.addSubview(sliderView)
        
       bottomContentView.addSubview(nextEpisodeButton)
       bottomContentView.addSubview(selectEpisodeButton)
        
       addSubview(failButton)
       addSubview(panelRightView)
        addSubview(fullScreen_TopADBannerView)
        addSubview(fullScreen_PauseADView)
       addSubview(placeholderStackView)
        addSubview(brightnessSliderView)

       addGestureRecognizer(tapGesture)
       addGestureRecognizer(panGesture)
       
       guard !config.isHiddenToolbarWhenStart else { return }
        jm_autoFadeOutTooView()
   }

    override func makeConstraints() {
        
        subTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-26.fit)
            make.left.equalTo(self).offset(12.fit)
            make.right.equalTo(self).offset(-12.fit)
        }
        
       topToolView.snp.makeConstraints { make in
           
           make.top.equalTo((config.isHiddenToolbarWhenStart ? -50 : 0))
           make.height.equalTo(50)
           
           make.left.right.equalToSuperview()
           
       }
       
        topToolGradualView.snp.makeConstraints { make in
            make.edges.equalTo(topToolView)
        }
        
       bottomToolView.snp.makeConstraints { make in
           make.left.right.equalToSuperview()
           if config.isHiddenToolbarWhenStart {
               make.top.equalTo(self.snp.bottom)
           } else {
               make.bottom.equalToSuperview()
           }
       }
        
        playCenterButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(44.fit)
        }
        
        playBackUpButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(playCenterButton.snp.left).offset(-65.fit)
            make.size.equalTo(44.fit)
        }
        
        playAdvanceButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(playCenterButton.snp.right).offset(65.fit)
            make.size.equalTo(44.fit)
        }
        
        playLockButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-12.fit)
            make.left.equalTo(10)
            make.size.equalTo(44.fit)
        }
        
        removeADButton.snp.makeConstraints { make in
            make.top.equalTo(playLockButton.snp.bottom).offset(8.fit)
            make.left.equalTo(playLockButton)
            make.size.equalTo(44.fit)
        }
        
        fastForwardView.snp.makeConstraints { make in
            make.height.equalTo(88.fit)
            make.width.equalTo(126.fit)
            make.center.equalToSuperview()
        }
        
        bottomToolGradualView.snp.makeConstraints { make in
            make.edges.equalTo(bottomToolView)
        }
        
       bottomSafeView.snp.makeConstraints { make in
           make.left.right.bottom.equalToSuperview()
           make.height.equalTo(0)
       }
    
       bottomContentView.snp.makeConstraints { make in
           make.left.right.top.equalToSuperview()
           make.height.equalTo(40)
           make.bottom.equalTo(bottomSafeView.snp.top)
       }
       loadingView.snp.makeConstraints { make in
           make.center.equalToSuperview()
           make.size.equalTo(40)
       }
       backButton.snp.makeConstraints { make in
           make.left.equalTo(8.fit)
           make.size.equalTo(40)
           make.centerY.equalToSuperview()
           
       }

        CCSubtitleButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints { make in
            make.right.equalTo(CCSubtitleButton.snp.left).offset(-8.fit)
            make.size.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(15)
            make.right.equalTo(shareButton.snp.left).offset(-15)
            make.centerY.height.equalToSuperview()
        }
        
       playButton.snp.makeConstraints { make in
           make.left.equalTo(10)
           make.size.equalTo(40)
           make.centerY.equalToSuperview()
       }
        
        nextEpisodeButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.left.equalTo(playButton.snp.right).offset(12.fit)
            make.size.equalTo(40.fit)
        }
        
        selectEpisodeButton.snp.makeConstraints { make in
            make.centerY.equalTo(playButton)
            make.right.equalTo(-30.fit)
            make.width.equalTo(120.fit)
            make.height.equalTo(40.fit)
        }
        
       fullButton.snp.makeConstraints { make in
           make.right.equalTo(-10)
           make.size.equalTo(24)
           make.centerY.equalToSuperview()
       }
       currentDurationLabel.snp.makeConstraints { make in
           make.left.equalTo(playButton.snp.right).offset(10)
           make.centerY.equalToSuperview()
       }
       totalDurationLabel.snp.makeConstraints { make in
           make.right.equalTo(fullButton.snp.left).offset(-10)
           make.centerY.equalToSuperview()
       }
       progressView.snp.makeConstraints { make in
           make.left.equalTo(currentDurationLabel.snp.right).offset(15)
           make.centerY.equalToSuperview()
           make.height.equalTo(2)
           make.right.equalTo(totalDurationLabel.snp.left).offset(-15)
       }
       sliderView.snp.makeConstraints { make in
           make.edges.equalTo(progressView)
       }
       failButton.snp.makeConstraints { make in
           make.center.equalToSuperview()
       }
        panelRightView.snp.makeConstraints { make in
           make.top.bottom.equalToSuperview()
           make.right.equalTo(morePanelWidth)
           make.width.equalTo(morePanelWidth)
       }
        
        fullScreen_TopADBannerView.snp.makeConstraints { make in
            make.top.equalTo(config.isHiddenToolbarWhenStart ? -50 : 00)
            make.width.equalTo(360+44)
            if HTConstIsiPad {
                make.height.equalTo(90)
            }
            else {
                make.height.equalTo(50)
            }
            
            make.centerX.equalTo(self)
        }
        
        fullScreen_PauseADView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(250)
            make.center.equalTo(self)
        }
        
       placeholderStackView.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }
        
        brightnessSliderView.snp.makeConstraints { make in
            make.height.equalTo(38.fit)
            make.width.equalTo(STATIC_BrightnessSliderViewWidth)
            make.top.equalTo(self).offset(28.fit)
            make.centerX.equalTo(self)
        }
   }
    
    func jm_reloadBottomContentViewConstraints() {
 
        if isHiddenToolView {
            
            return
        }
        
        if screenState == .fullScreen {
            
            bottomContentView.snp.remakeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(100)
                make.bottom.equalTo(bottomSafeView.snp.top)
            }
            
            currentDurationLabel.snp.remakeConstraints { make in
                make.left.equalTo(safeAreaInsets.left + 10.fit)
                
                if HTConstIsiPad {
                    
                    make.top.equalTo(bottomContentView).offset(26)
                }
                else {
                    make.top.equalTo(bottomContentView).offset(26.fit)
                }
                
            }
            totalDurationLabel.snp.remakeConstraints { make in
                
                if HTConstIsiPad {
                    make.right.equalTo(-30)
                }
                else {
                    make.right.equalTo(-30.fit)
                }
                
                
                make.centerY.equalTo(currentDurationLabel)
            }
            progressView.snp.remakeConstraints { make in
                make.left.equalTo(currentDurationLabel.snp.right).offset(15)
                make.centerY.equalTo(currentDurationLabel)
                make.height.equalTo(2)
                make.right.equalTo(totalDurationLabel.snp.left).offset(-15)
            }
            sliderView.snp.remakeConstraints { make in
                make.edges.equalTo(progressView)
            }
            
            playButton.snp.remakeConstraints { make in
                make.left.equalTo(safeAreaInsets.left + 12.fit)
                make.size.equalTo(40)
                
                if HTConstIsiPad {
                    
                    make.top.equalTo(currentDurationLabel.snp.bottom).offset(12)
                }
                else {
                    
                    make.top.equalTo(currentDurationLabel.snp.bottom).offset(12.fit)
                }
                
                
            }
            
            nextEpisodeButton.snp.remakeConstraints { make in
                make.centerY.equalTo(playButton)
                if HTConstIsiPad {
                    make.left.equalTo(playButton.snp.right).offset(12)
                }
                else {
                    make.left.equalTo(playButton.snp.right).offset(12.fit)
                }
                
                make.size.equalTo(40.fit)
            }
            
            selectEpisodeButton.snp.remakeConstraints { make in
                make.centerY.equalTo(playButton)
                if HTConstIsiPad {
                    make.right.equalTo(-30)
                }
                else {
                    make.right.equalTo(-30.fit)
                }
                make.width.equalTo(120.fit)
                make.height.equalTo(40.fit)
            }
            
            /// 移出屏幕外，横屏模式不显示全屏按钮
           fullButton.snp.remakeConstraints { make in
               make.right.equalTo(100)
               make.size.equalTo(24)
               make.centerY.equalToSuperview()
           }
           
            playBackUpButton.isHidden = false
            playAdvanceButton.isHidden = false
            playLockButton.isHidden = false
            removeADButton.isHidden = false
            nextEpisodeButton.isHidden = false
            selectEpisodeButton.isHidden = false
        }
        else {
            
            playBackUpButton.isHidden = true
            playAdvanceButton.isHidden = true
            playLockButton.isHidden = true
            removeADButton.isHidden = true
            nextEpisodeButton.isHidden = true
            selectEpisodeButton.isHidden = true
            
            bottomContentView.snp.remakeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(40)
                make.bottom.equalTo(bottomSafeView.snp.top)
            }
            
            playButton.snp.remakeConstraints { make in
                make.left.equalTo(10)
                make.size.equalTo(40)
                make.centerY.equalToSuperview()
            }
            
            nextEpisodeButton.snp.remakeConstraints { make in
                make.centerY.equalTo(playButton)
                make.left.equalTo(playButton.snp.right).offset(12.fit)
                make.size.equalTo(40.fit)
            }
            
            selectEpisodeButton.snp.remakeConstraints { make in
                make.centerY.equalTo(playButton)
                make.right.equalTo(-30.fit)
                make.width.equalTo(120.fit)
                make.height.equalTo(40.fit)
            }
            
           fullButton.snp.remakeConstraints { make in
               make.right.equalTo(-10)
               make.size.equalTo(24)
               make.centerY.equalToSuperview()
           }
           currentDurationLabel.snp.remakeConstraints { make in
               make.left.equalTo(playButton.snp.right).offset(10)
               make.centerY.equalToSuperview()
           }
           totalDurationLabel.snp.remakeConstraints { make in
               make.right.equalTo(fullButton.snp.left).offset(-10)
               make.centerY.equalToSuperview()
           }
           progressView.snp.remakeConstraints { make in
               make.left.equalTo(currentDurationLabel.snp.right).offset(15)
               make.centerY.equalToSuperview()
               make.height.equalTo(2)
               make.right.equalTo(totalDurationLabel.snp.left).offset(-15)
           }
           sliderView.snp.remakeConstraints { make in
               make.edges.equalTo(progressView)
           }
        }
        
        bottomToolView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        bottomToolGradualView.snp.remakeConstraints { make in
            make.edges.equalTo(bottomToolView)
        }
        
        bottomToolView.layoutIfNeeded()
        bottomToolGradualView.layoutIfNeeded()
        
    }
    
    func jm_reloadTopContentViewConstraints() {
        
        if screenState == .fullScreen {
            CCSubtitleButton.snp.updateConstraints { make in
                make.right.equalTo(-30.fit)
            }
        } else {
            CCSubtitleButton.snp.updateConstraints { make in
                make.right.equalTo(-10)
            }
        }
    }

   override func updateConfig() {
       currentVideoGravity = config.videoGravity
       topToolView.isHidden = screenState == .small ? config.topBarHiddenStyle != .never : config.topBarHiddenStyle == .always
       moreButton.isHidden = config.isHiddenMorePanel
       //topToolView.backgroundColor = config.color.topToobar
       //bottomToolView.backgroundColor = config.color.bottomToolbar
       progressView.trackTintColor = config.color.progress
       progressView.progressTintColor = config.color.progressBuffer
       sliderView.minimumTrackTintColor = config.color.progressFinished
       loadingView.updateWithConfigure { $0.backgroundColor = self.config.color.loading }
       isHiddenToolView = config.isHiddenToolbarWhenStart

       backButton.sd_setImage(with: HTImageHelper.imageWithCount(39), for: .normal)

       CCSubtitleButton.setImage(HTImageHelper.imageWithName("icon_subtitle_disable"), for: .disabled)
       CCSubtitleButton.setImage(HTImageHelper.imageWithName("icon_subtitle_normal"), for: .normal)
       CCSubtitleButton.setImage(HTImageHelper.imageWithName("icon_subtitle_selected"), for: .selected)
       shareButton.sd_setImage(with: HTImageHelper.imageWithCount(124), for: .normal)
       playButton.sd_setImage(with: HTImageHelper.imageWithCount(180), for: .normal)
       playButton.sd_setImage(with: HTImageHelper.imageWithCount(181), for: .selected)
       fullButton.sd_setImage(with: HTImageHelper.imageWithCount(83), for: .normal)
       fullButton.sd_setImage(with: HTImageHelper.imageWithCount(83), for: .selected)
       sliderView.setThumbImage(config.image.slider, for: .normal)
       
       playCenterButton.sd_setImage(with: HTImageHelper.imageWithCount(185), for: .normal)
       playCenterButton.sd_setImage(with: HTImageHelper.imageWithCount(186), for: .selected)
       
       playBackUpButton.sd_setImage(with: HTImageHelper.imageWithCount(187), for: .normal)
       playAdvanceButton.sd_setImage(with: HTImageHelper.imageWithCount(188), for: .normal)

       playLockButton.sd_setImage(with: HTImageHelper.imageWithCount(182), for: .normal)
       removeADButton.sd_setImage(with: HTImageHelper.imageWithCount(184), for: .normal)
       nextEpisodeButton.sd_setImage(with: HTImageHelper.imageWithCount(179), for: .normal)
       
       playBackUpButton.isHidden = true
       playAdvanceButton.isHidden = true
       playLockButton.isHidden = true
       removeADButton.isHidden = true
       fullScreen_TopADBannerView.isHidden = true
       fullScreen_PauseADView.isHidden = true
       nextEpisodeButton.isHidden = true
       selectEpisodeButton.isHidden = true
   }
    
    // MARK: ---公共方法
    override func animationLayout(safeAreaInsets: UIEdgeInsets, to screenState: HTPlayerScreenState) {
        
        subTitleLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(self).offset(screenState == .small ? -26.fit : -16.fit)
            make.left.equalTo(self).offset(safeAreaInsets.left + 12.fit)
            make.right.equalTo(self).offset(-(12.fit + safeAreaInsets.left))
        }
        
        bottomSafeView.snp.updateConstraints { make in
            make.height.equalTo(safeAreaInsets.bottom)
        }
        backButton.snp.updateConstraints { make in
            make.left.equalTo(screenState == .small ? 8.fit : safeAreaInsets.left + 10)
        }
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(backButton.snp.right).offset(screenState == .small ? 15 : 10)
            make.right.equalTo(shareButton.snp.left).offset(screenState == .small ? -15 : -10)
        }
        /*
        moreButton.snp.updateConstraints { make in
            make.right.equalTo(screenState == .small ? 40 : -safeAreaInsets.left - 10)
        }
         */
        playButton.snp.updateConstraints { make in
            make.left.equalTo(safeAreaInsets.left + 22.fit)
        }
        
        /// 横屏不再显示全屏按钮
//        fullButton.snp.updateConstraints { make in
//            make.right.equalTo(-safeAreaInsets.right - 10)
//        }
        
        playLockButton.snp.updateConstraints { make in
            make.left.equalTo( safeAreaInsets.left + 10.fit)
        }
        
        fullButton.isSelected = screenState == .fullScreen

        topToolView.isHidden = screenState == .small ? config.topBarHiddenStyle != .never : config.topBarHiddenStyle == .always
        
        if screenState == .fullScreen {
            
            if isHiddenToolView == false {
                
                playCenterButton.isHidden = false
            }
            else {
                
                playCenterButton.isHidden = true
            }
 
        }
        else {
            
            playCenterButton.isHidden = true
        }
    }

    override func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(min(max(0, progress), 1), animated: animated)
    }

    override func setSliderProgress(_ progress: Float, animated: Bool) {
        sliderView.setValue(min(max(0, progress), 1), animated: animated)
    }

    override func setTotalDuration(_ totalDuration: TimeInterval) {
        
        self.totalDuration = totalDuration
        
        let time = Int(floor(totalDuration))
        let hours = time / 3600
        let minutes = hours > 0 ? (time - 3600*hours)/60 : time / 60
        let seconds = time % 60
        totalDurationLabel.text = hours == .zero ? String(format: "%02ld:%02ld", minutes, seconds) : String(format: "%02ld:%02ld:%02ld", hours, minutes, seconds)
    }

    override func setCurrentDuration(_ currentDuration: TimeInterval) {
        //print("\nself.currentDuration = \(self.currentDuration)")
        let time = Int(floor(currentDuration))
        let hours = time / 3600
        let minutes = hours > 0 ? (time - 3600*hours)/60 : time / 60
        let seconds = time % 60
        currentDurationLabel.text = hours == .zero ? String(format: "%02ld:%02ld", minutes, seconds) : String(format: "%02ld:%02ld:%02ld", hours, minutes, seconds)
        
        self.currentDuration = currentDuration
        
        /// 字幕开启
        if self.subTitleStatus == 2 {
            /// 如果有字幕则加载字幕(另加字幕调整时间)
//            if let parsedPayload = parsedPayload {
//                self.subTitleLabel.text = HTSubtitles.jm_searchSubtitles(parsedPayload, self.currentDuration + self.subTitleAdjustDuration)
//            }
            
            /// 如果有字幕则加载字幕(另加字幕调整时间，调整为根据索引寻找)
            if let parsedPayloadArray = parsedPayloadArray {
                
                self.subTitleLabel.text = var_subtitlesParseObject.jm_searchSubtitlesWithArray(parsedPayloadArray, self.currentDuration + self.subTitleAdjustDuration)
            }
        }
        else {
            
            if self.subTitleLabel.text?.count ?? 0 > 0 {
                
                self.subTitleLabel.text = ""
            }
  
        }
        
        
    }
    
    override func reloadScreenState() {
        
        switch screenState {
        case .small:
            topToolView.isHidden = config.topBarHiddenStyle != .never
            jm_hiddenMorePanel()
        case .animating:
            break
        case .fullScreen:
            topToolView.isHidden = config.topBarHiddenStyle == .always
        }
        
        jm_reloadBottomContentViewConstraints()
        jm_reloadTopContentViewConstraints()
    }
    
    override func reloadPlayState() {
        
        switch playState {
        case .unknow:
            sliderView.isUserInteractionEnabled = false
            failButton.isHidden = true
            playButton.isSelected = false
            playCenterButton.isSelected = false
            placeholderStackView.isHidden = placeholderView == nil
            loadingView.startAnimation()
//            if screenState != .fullScreen {playCenterButton.isHidden = true}
        case .waiting:
            sliderView.isUserInteractionEnabled = false
            failButton.isHidden = true
            placeholderStackView.isHidden = true
            loadingView.startAnimation()
//            if screenState != .fullScreen {playCenterButton.isHidden = true}
        case .readyToPlay:
            sliderView.isUserInteractionEnabled = true
        case .playing:
            sliderView.isUserInteractionEnabled = true
            failButton.isHidden = true
            playButton.isSelected = true
            playCenterButton.isSelected = true
            placeholderStackView.isHidden = true
            loadingView.stopAnimation()
//            if screenState != .fullScreen {playCenterButton.isHidden = true}
        case .buffering:
            sliderView.isUserInteractionEnabled = true
            failButton.isHidden = true
            placeholderStackView.isHidden = true
            loadingView.startAnimation()
//            if screenState != .fullScreen {playCenterButton.isHidden = true}
        case .failed:
            sliderView.isUserInteractionEnabled = false
            failButton.isHidden = false
            loadingView.stopAnimation()
//            if screenState != .fullScreen {playCenterButton.isHidden = false}
        case .pause:
            sliderView.isUserInteractionEnabled = true
            playButton.isSelected = false
            playCenterButton.isSelected = false
        case .ended:
            sliderView.isUserInteractionEnabled = true
            failButton.isHidden = true
            playButton.isSelected = false
            playCenterButton.isSelected = false
            placeholderStackView.isHidden = placeholderView == nil
            loadingView.stopAnimation()
//            if screenState != .fullScreen {playCenterButton.isHidden = false}
        }
    }
    
    override func reloadUI() {
        
        titleLabel.attributedText = title
        
        if removedAD {
            
            removeADButton.snp.makeConstraints { make in
                make.top.equalTo(playLockButton.snp.bottom).offset(8.fit)
                make.left.equalTo(playLockButton)
                make.size.equalTo(0)
            }
        }
        else {
            
            removeADButton.snp.makeConstraints { make in
                make.top.equalTo(playLockButton.snp.bottom).offset(8.fit)
                make.left.equalTo(playLockButton)
                make.size.equalTo(44.fit)
            }
        }
    }
    
    override func reloadSubTitleStatus() {
        
        switch (self.subTitleStatus) {
        case 0:
            
            self.CCSubtitleButton.isEnabled = false
            
            break
        case 1:
            
            self.CCSubtitleButton.isEnabled = true
            
            self.CCSubtitleButton.isSelected = false
            
            break
        case 2:
            
            self.CCSubtitleButton.isEnabled = true
            
            self.CCSubtitleButton.isSelected = true
            
            break
        default:
            break
        }
    }
    
    override func jm_setHiddenFullScreenRightPanelView() {
        
        self.isShowMorePanel = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topToolGradualView.layer.sublayers?.removeAll()
        bottomToolGradualView.layer.sublayers?.removeAll()
        
        topToolGradualView.setGradientColorsAndVertical([YNHexString("#000000",alpha: 0.5).cgColor,YNHexString("#000000",alpha: 0.01).cgColor], true)
        
        bottomToolGradualView.setGradientColorsAndVertical([YNHexString("#000000",alpha: 0.01).cgColor,YNHexString("#000000",alpha: 0.5).cgColor], true)
    }
    
    override func hidden_MorePanView() {
        
        panelRightView.snp.updateConstraints { make in
            make.right.equalTo(morePanelWidth)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func setSelectEpisodeButtonTitle(_ title: String) {
        
        self.selectEpisodeButton.setTitle(title, for: .normal)
    }
}


// MARK:---objc

@objc private extension HTPlayerContentView {
    func jm_tapAction() {
        if isShowMorePanel {
            isShowMorePanel = false
        } else {
            isHiddenToolView ? jm_showToolView() : jm_hiddenToolView()
        }
    }

    func jm_panDirection(_ pan: UIPanGestureRecognizer) {
        let locationPoint = pan.location(in: self)
        let veloctyPoint = pan.velocity(in: self)
        switch pan.state {
        case .began:
            
            self.panDirectionBegainCurrentDuration = self.currentDuration
            
            if abs(veloctyPoint.x) > abs(veloctyPoint.y) {
                //print("veloctyPoint.x = \(veloctyPoint.x) veloctyPoint.y = \(veloctyPoint.y)")
                panDirection = .horizontal
            } else {
                panDirection = locationPoint.x < bounds.width * 0.5 ? .leftVertical : .rightVertical
            }
        case .changed:
            switch panDirection {
            case .horizontal:
                
                fastForwardView.isHidden = false
                
                let time = Int(floor(panDirectionBegainCurrentDuration))
                let hours = time / 3600
                let minutes = hours > 0 ? (time - 3600*hours)/60 : time / 60
                let seconds = time % 60
                let timeText = hours == .zero ? String(format: "%02ld:%02ld", minutes, seconds) : String(format: "%02ld:%02ld:%02ld", hours, minutes, seconds)
                
                fastForwardView.text = "\(timeText)/\(self.totalDurationLabel.text ?? "")"
                
                /// 手势在水平方向上的速度为正，即向右滑动
                if veloctyPoint.x > 0 {
                    
                    // 水平向右滑动
                    
                    self.fastForwardView.jm_setIsFastForward(true)
                    
                    print("水平向右滑动 \(self.currentDuration) self.totalDuration = \(self.totalDuration)")
                    
                    if self.panDirectionBegainCurrentDuration < (self.totalDuration - 1) {
                        
                        self.panDirectionBegainCurrentDuration = self.panDirectionBegainCurrentDuration + 1
                    }
                    
                    
                }
                else {
                    
                    // 水平向左滑动
                    print("水平向左滑动 \(self.currentDuration)")
                    
                    self.fastForwardView.jm_setIsFastForward(false)
                    
                    if self.panDirectionBegainCurrentDuration > 1 {
                        
                        self.panDirectionBegainCurrentDuration = self.panDirectionBegainCurrentDuration - 1
                    }

                }
                
                break
            case .leftVertical:
                UIScreen.main.brightness -= veloctyPoint.y / 10000
                
                print("\n UIScreen.main.brightness = \(UIScreen.main.brightness)")
                brightnessSliderView.isHidden = false
                brightnessSliderView.var_sliderValue = UIScreen.main.brightness
                

            case .rightVertical:
                volumeSlider?.value -= Float(veloctyPoint.y / 10000)
            default:
                break
            }
        case .ended, .cancelled:
            
            if panDirection == .horizontal {
                
                if self.panDirectionBegainCurrentDuration != self.currentDuration {
                    
                    delegate?.jm_didClickFastForward(self, fastForwardTime: self.panDirectionBegainCurrentDuration)
                }
            }
            
            panDirection = .unknow
            
            fastForwardView.isHidden = true
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                
                DispatchQueue.main.async {

                    self.brightnessSliderView.jm_hidden()
                }
            }
     
        default:
            break
        }
    }

    func jm_backButtonAction() {
        delegate?.jm_didClickBackButton(in: self)
    }

    func jm_moreButtonAction() {
        jm_showMorePanel()
    }
    
    func jm_CCSubTitleButtonAction() {
        
        delegate?.jm_didClickSubTitleSettingButton(in: self, fullState: screenState == .fullScreen, button: CCSubtitleButton, index: 1)
     
        if screenState == .fullScreen {
            
            jm_moreButtonAction()
        }
 
    }
    
    func jm_shareButtonAction() {
        
        delegate?.jm_didClickShareButton(in: self)
    }

    func jm_playButtonAction(_ button: UIButton) {
        delegate?.contentView(self, didClickPlayButton: button.isSelected)
    }
    
    func jm_playCenterButtonAction(_ button: UIButton) {
        delegate?.contentView(self, didClickPlayButton: button.isSelected)
    }

    func jm_fullButtonAction(_ button: UIButton) {

        /// 重新开始息屏计时器
        jm_autoFadeOutTooView()

        delegate?.contentView(self, didClickFullButton: button.isSelected)
    }

    func jm_failButtonAction() {
        delegate?.jm_didClickFailButton(in: self)
    }

    func jm_progressSliderTouchBegan(_ slider: HTSlider) {
        jm_cancelAutoFadeOutTooView()
        delegate?.contentView(self, sliderTouchBegan: slider)
    }

    func jm_progressSliderValueChanged(_ slider: HTSlider) {
        delegate?.contentView(self, sliderValueChanged: slider)
    }

    func jm_progressSliderTouchEnded(_ slider: HTSlider) {
        jm_autoFadeOutTooView()
        delegate?.contentView(self, sliderTouchEnded: slider)
    }
    
    func jm_playBackUpAction(_ button: UIButton) {
        delegate?.jm_didClickPlayBackUpButton(in: self)
    }
    
    func jm_playAdvanceAction(_ button: UIButton) {
        delegate?.jm_didClickPlayAdvanceButton(in: self)
    }
    
    func jm_playLockAction(_ button: UIButton) {
        
        self.lockScreen = !self.lockScreen
        
        if self.lockScreen {
            self.playLockButton.sd_setImage(with: HTImageHelper.imageWithCount(183), for: .normal)
        }
        else {
            self.playLockButton.sd_setImage(with: HTImageHelper.imageWithCount(182), for: .normal)
        }
        
        self.jm_showToolView()
        
        delegate?.jm_didClickPlayLockButton(in: self, lock: self.lockScreen)
    }
    
    func jm_removeADAction(_ button: UIButton) {
        delegate?.jm_didClickPlayRemoveADButton(in: self)
    }
    
    func jm_playNextEpisodeAction(_ button: UIButton) {
        delegate?.jm_didClickPlayNextEpisodeButton(in: self)
    }
    
    func jm_selectEpisodeAction(_ button: UIButton) {
        
        delegate?.jm_didClickPlaySelectEpisodeButton(in: self, button: button, index: 0)
        
        jm_moreButtonAction()
    }
 
}

// MARK:---私有方法

private extension HTPlayerContentView {
    
    func jm_showMorePanel() {
        isShowMorePanel = true
    }

    func jm_hiddenMorePanel() {
        isShowMorePanel = false
    }

    func jm_showToolView() {
        
        isHiddenToolView = false
        
        if self.lockScreen {
            
            self.playLockButton.isHidden = false
            
            topToolView.snp.updateConstraints { make in
                make.top.equalTo(-50)
            }
            bottomToolView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.snp.bottom)
            }
            playCenterButton.isHidden = true
            playBackUpButton.isHidden = true
            playAdvanceButton.isHidden = true
            removeADButton.isHidden = true
        
            nextEpisodeButton.isHidden = true
            selectEpisodeButton.isHidden = true
            
        }
        else {
            topToolView.snp.updateConstraints { make in
                
                make.top.equalTo(0)
                
            }
            bottomToolView.snp.remakeConstraints { make in
                make.left.right.bottom.equalToSuperview()
            }
            /*
            playCenterButton.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(44.fit)
            }*/
            
            if screenState == .fullScreen {
                
                playCenterButton.isHidden = false
            }
            else {
                
                playCenterButton.isHidden = true
            }
            
            
         
            jm_reloadBottomContentViewConstraints()
            
            UIView.animate(withDuration: 0.25, delay: 0) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            } completion: { _ in
                self.jm_autoFadeOutTooView()
            }
        }
        
        
    }

    func jm_hiddenToolView() {
        isHiddenToolView = true
        topToolView.snp.updateConstraints { make in
            make.top.equalTo(-50)
        }
        bottomToolView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
        }
        /*
        playCenterButton.snp.remakeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(44.fit)
        }*/
        
        playCenterButton.isHidden = true
        playBackUpButton.isHidden = true
        playAdvanceButton.isHidden = true
        playLockButton.isHidden = true
        removeADButton.isHidden = true
        nextEpisodeButton.isHidden = true
        selectEpisodeButton.isHidden = true
        
        UIView.animate(withDuration: 0.25, delay: 0) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        } completion: { _ in
            self.jm_cancelAutoFadeOutTooView()
        }
    }

    func jm_autoFadeOutTooView() {
        autoFadeOutTimer = HTGCDTimer(interval: 0, delaySecs: 0.25 + config.autoFadeOut, repeats: false, action: { [weak self] _ in
            self?.jm_hiddenToolView()
        })
        autoFadeOutTimer?.start()
    }

    func jm_cancelAutoFadeOutTooView() {
        autoFadeOutTimer?.cancel()
    }
    
}

extension HTPlayerContentView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !placeholderStackView.isHidden {
            return false
        } else if panelRightView.bounds.contains(touch.location(in: panelRightView)) {
            return false
        } else if topToolView.bounds.contains(touch.location(in: topToolView)) {
            return false
        } else if bottomToolView.bounds.contains(touch.location(in: bottomToolView)) {
            return false
        } else if gestureRecognizer == panGesture {
            guard screenState != .animating else { return false }
            if config.gestureInteraction == .none { return false }
            if config.gestureInteraction == .small, screenState == .fullScreen { return false }
            if config.gestureInteraction == .fullScreen, screenState == .small { return false }
        }
        return true
    }
}

/// 字幕加载
extension HTPlayerContentView {
    
    func jm_loadSTRFile(fileFromRemote filePath: URL, encoding: String.Encoding = .utf8) {
        
        let dataTask = URLSession.shared.dataTask(with: filePath) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                
                //Check status code
                if statusCode != 200 {
                    NSLog("Subtitle Error: \(httpResponse.statusCode) - \(error?.localizedDescription ?? "")")
                    return
                }
            }
            
            // Update UI elements on main thread
            DispatchQueue.main.async {
                self.subTitleLabel.text = ""
                if let checkData = data as Data?, let contents = String(data: checkData, encoding: encoding) {
                    self.jm_show(subtitles: contents)
                }
            }
        }
        dataTask.resume()
    }
    
    func jm_loadSTRData(fileData data: Data?) {
        
        if let data = data {
            
            DispatchQueue.main.async {
                self.subTitleLabel.text = ""
                if let contents = String(data: data, encoding: .utf8) {
                    self.jm_show(subtitles: contents)
                }
            }
        }
        
        
    }
    
    func jm_show(subtitles string: String) {
        // Parse
        parsedPayload = try? HTSubtitles.jm_parseSubRip(string)
        
        delegate?.jm_contentView(self, subTitleLoadComplete: parsedPayload)
        
        if let parsedPayload = parsedPayload {
            
            DispatchQueue.global().async {
           
                var var_items:[NSDictionary] = []
                
                if let var_keys = parsedPayload.allKeys as? [NSString] {
                    
                    let var_sortedKeys = var_keys.sorted { $0.intValue < $1.intValue }
                    
                    for var_key in var_sortedKeys {
                        
                        if let var_dic = parsedPayload[var_key] as? NSDictionary {
                            
                            var_items.append(var_dic)
                        }
                    }

                }
                
                self.parsedPayloadArray = var_items
                
                
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    func jm_showByDictionary(dictionaryContent: NSMutableDictionary) {
        // Add Dictionary content direct to Payload
        parsedPayload = dictionaryContent
        
        if let parsedPayload = parsedPayload {
            
            DispatchQueue.global().async {
           
                var var_items:[NSDictionary] = []
                
                if let var_keys = parsedPayload.allKeys as? [NSString] {
                    
                    let var_sortedKeys = var_keys.sorted { $0.intValue < $1.intValue }
                    
                    for var_key in var_sortedKeys {
                        
                        if let var_dic = parsedPayload[var_key] as? NSDictionary {
                            
                            var_items.append(var_dic)
                        }
                    }

                }
                
                self.parsedPayloadArray = var_items
                
                
                DispatchQueue.main.async {
                    
                }
            }
        }
 
        
    }

}
