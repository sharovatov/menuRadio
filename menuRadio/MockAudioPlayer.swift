//
//  MockAudioPlayer.swift
//  menuRadio
//
//  Created by Vitaliy Sharovatov on 08.02.2025.
//
import Foundation

public class MockAudioPlayer: AudioPlayerProtocol {
    public private(set) var isPlaying = false
    
    public var onPlaybackStateChange: ((Bool) -> Void)?

    public init() {}

    public func play(url: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.isPlaying = true
            self?.onPlaybackStateChange?(true)
        }
        
    }

    public func stop() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.isPlaying = false
            self?.onPlaybackStateChange?(false)
        }
    }
    
}
