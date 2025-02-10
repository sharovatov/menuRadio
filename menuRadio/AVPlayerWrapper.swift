//
//  AVPlayerWrapper.swift
//  menuRadio
//
//  Created by Vitaliy Sharovatov on 08.02.2025.
//

import AVFoundation

public class AVPlayerWrapper: AudioPlayerProtocol {

    public init() {} 

    private var player: AVPlayer?
    private var playerObserver: NSKeyValueObservation?
    private var rateObserver: NSKeyValueObservation?
    private var bufferObserver: NSKeyValueObservation?
    private var errorObserver: NSKeyValueObservation?
    
    public private(set) var isPlaying = false
    public var onPlaybackStateChange: ((Bool) -> Void)? 

    private var playbackStarted = false

    public func play(url: String) {
        guard let streamURL = URL(string: url), streamURL.scheme != nil else {
            isPlaying = false
            onPlaybackStateChange?(false)
            return
        }
        
        player = AVPlayer(url: streamURL)
        player?.play()
        
        // 4 secs is reasonable?
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            if self?.playbackStarted == false {
                self?.player?.pause()
                self?.player = nil
                self?.onPlaybackStateChange?(false)
            }
        }
        
        // avplayer is weird — either isPlaybackLikelyToKeepUp fires or rate > 0
        
        // isPlaybackLikelyToKeepUp
        bufferObserver = player?.currentItem?.observe(\.isPlaybackLikelyToKeepUp, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                if item.isPlaybackLikelyToKeepUp {
                    self?.isPlaying = true
                    self?.playbackStarted = true
                    self?.onPlaybackStateChange?(true)
                }
            }
        }

        // rate > 0
        rateObserver = player?.observe(\.rate, options: [.new, .initial]) { [weak self] player, _ in
            DispatchQueue.main.async {
                if player.rate > 0, self?.playbackStarted == true {
                    self?.isPlaying = true
                    self?.onPlaybackStateChange?(true)
                }
            }
        }

        // network errors
        errorObserver = player?.currentItem?.observe(\.error, options: [.new]) { [weak self] item, _ in
            DispatchQueue.main.async {
                if let error = item.error {
                    self?.isPlaying = false
                    self?.onPlaybackStateChange?(false)
                }
            }
        }
    }

    public func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        onPlaybackStateChange?(false)

        bufferObserver?.invalidate()
        rateObserver?.invalidate()
        errorObserver?.invalidate()

        bufferObserver = nil
        rateObserver = nil
        errorObserver = nil
    }
}
