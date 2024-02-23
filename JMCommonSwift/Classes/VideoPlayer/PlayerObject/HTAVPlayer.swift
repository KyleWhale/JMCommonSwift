//
//  HTAVPlayer.swift
//  Cartoon
//
//  Created by James on 2023/5/5.
//

import Foundation
import AVFoundation

public class HTAVPlayer: HTPlayerBaseView {
    
    private var waitReadyToPlayState: HTWaitReadyToPlayState = .nomal
    
    private var statusObserve: NSKeyValueObservation?
    
    private var isPlaybackLikelyToKeepUpObserve: NSKeyValueObservation?

    private var loadedTimeRangesObserve: NSKeyValueObservation?

    private var playbackBufferEmptyObserve: NSKeyValueObservation?
    
    private var player: AVPlayer?
    
    var kaDunCount:Int = 0

    private var playerItem: AVPlayerItem? {
        didSet {
            guard playerItem != oldValue else { return }
            if let oldPlayerItem = oldValue {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: oldPlayerItem)
            }
            guard let playerItem = playerItem else { return }
            NotificationCenter.default.addObserver(self, selector: #selector(didPlaybackEnds), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

            statusObserve = playerItem.observe(\.status, options: [.new]) { [weak self] _, _ in
                self?.observeStatusAction()
            }
            
            isPlaybackLikelyToKeepUpObserve = playerItem.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] _, _ in
                
                if let self = self {
                    
                    self.isPlaybackLikelyToKeepUp = playerItem.isPlaybackLikelyToKeepUp
                    
                    if !self.isPlaybackLikelyToKeepUp && playerItem.isPlaybackBufferEmpty == true {
                        
                        //print("正在卡顿")
                        
                        self.kaDunCount = self.kaDunCount + 1
                        DispatchQueue.main.async {
                            self.delegate?.didKaDunCount(in: self, count: self.kaDunCount)
                        }
                    }
                }
            }
            
            
        }
    }
    
    override func commonInit() {
    
        if let url = url {
            
            playerItem = AVPlayerItem(asset: .init(url: url))
            player = AVPlayer(playerItem: playerItem)
            (layer as? AVPlayerLayer)?.player = player
            
        }
        
    }
    
    @objc func didPlaybackEnds() {
        
        DispatchQueue.main.async {
            self.delegate?.didPlaybackEnds(in: self)
        }
    }
    
    override func pause() {
        player?.pause()
    }
    
    override func play() {
        
        player?.play()
        player?.rate = rate
    }
    
    override func getCurrentTime() -> Double {
        guard let playerItem = playerItem else { return 0.0 }
        return CMTimeGetSeconds(playerItem.currentTime())
    }
    
    override func seekTo(to time: Double) {
        
        var var_isPlaying = false
        
        if player?.rate != 0.0 {
            var_isPlaying = true // 记录拖动前的播放状态
        }
        
        let dragedCMTime = CMTimeMake(value: Int64(ceil(time)), timescale: 1)
        player?.seek(to: dragedCMTime, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: {[weak self] complete in
            
            if complete {
                
                if var_isPlaying {
                    
                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.26) {
                        
                        DispatchQueue.main.async {
                           
                            if let self = self {
                                
                                self.play()
                                
                            }
                            
                        }
                    }
                    
                }
            }
        })
        
    }
}

public extension HTAVPlayer {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.classForCoder()
    }
}

private extension HTAVPlayer {
    func observeStatusAction() {
        guard let playerItem = playerItem else { return }
        
        totalDuration = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        
        self.isPlaybackLikelyToKeepUp = playerItem.isPlaybackLikelyToKeepUp
        
        if !self.isPlaybackLikelyToKeepUp && playerItem.isPlaybackBufferEmpty == true {
            
            //print("正在卡顿")
            
            kaDunCount = kaDunCount + 1
            DispatchQueue.main.async {
                self.delegate?.didKaDunCount(in: self, count: self.kaDunCount)
            }
        }
        
        self.playStatus = HTPlayerStatus(rawValue: playerItem.status.rawValue) ?? .unknown
        
        if self.playStatus == .readyToPlay {
            
            loadedTimeRangesObserve = playerItem.observe(\.loadedTimeRanges, options: [.new]) { [weak self] _, _ in
                self?.observeLoadedTimeRangesAction()
            }

            playbackBufferEmptyObserve = playerItem.observe(\.isPlaybackBufferEmpty, options: [.new]) { [weak self] _, _ in
                self?.observePlaybackBufferEmptyAction()
            }
        }
        
        
        
        DispatchQueue.main.async {
            self.delegate?.observeStatusAction(in: self)
        }

    }

    func observeLoadedTimeRangesAction() {
        guard let timeInterval = availableDuration() else { return }
        guard let duration = playerItem?.duration else { return }
        let totalDuration = TimeInterval(CMTimeGetSeconds(duration))
//        contentView.setProgress(Float(timeInterval / totalDuration), animated: false)
        
        DispatchQueue.main.async {
            self.delegate?.setProgress(in: self, progress: Double(timeInterval / totalDuration), animation: false)
        }
    }

    func observePlaybackBufferEmptyAction() {
        guard playerItem?.isPlaybackBufferEmpty ?? false else { return }
        bufferingSomeSecond()
    }
}

private extension HTAVPlayer {
    func availableDuration() -> TimeInterval? {
        guard let timeRange = playerItem?.loadedTimeRanges.first?.timeRangeValue else { return nil }
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        return .init(startSeconds + durationSeconds)
    }

    func bufferingSomeSecond() {
        guard playerItem?.status == .readyToPlay else { return }
//        guard contentView.playState != .failed else { return }

        DispatchQueue.main.async {
            self.delegate?.bufferingSomeSecond(in: self)
        }
        
    }
}
