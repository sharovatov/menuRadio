//
//  RadioPlayer.swift
//  menuRadio
//
//  Created by Vitaliy Sharovatov on 08.02.2025.
//
import AVFoundation

public protocol AudioPlayerProtocol {
    var isPlaying: Bool { get }
    var onPlaybackStateChange: ((Bool) -> Void)? { get set }

    func play(url: String)
    func stop()
}


public class RadioPlayer {
    
    private var audioPlayer: AudioPlayerProtocol
    private var _isPlaying: Bool = false
    public var isPlaying: Bool { return _isPlaying }
    
    public var onPlaybackStateChange: ((Bool) -> Void)?
    

    
    public init(audioPlayer: AudioPlayerProtocol) {
        self.audioPlayer = audioPlayer
        
        self.audioPlayer.onPlaybackStateChange = { [weak self] isPlaying in
            self?.handlePlaybackStateChange(isPlaying)
        }
    }
    
    public func play(url: String) {
        if isPlaying { stop(); } 
        audioPlayer.play(url: url)
    }
    
    public func stop() {
        if !isPlaying { return }
        audioPlayer.stop()
        _isPlaying = false

    }

    private func handlePlaybackStateChange(_ isPlaying: Bool) {
        self._isPlaying = isPlaying
        self.onPlaybackStateChange?(isPlaying)
    }
    
}

