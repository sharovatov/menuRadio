//
//  menuRadioTests.swift
//  menuRadioTests
//
//  Created by Vitaliy Sharovatov on 08.02.2025.
//

import Testing
@testable import menuRadio
import AVFoundation

// next tick essentially, 150ms
let TEST_ASYNC_WAIT: UInt64 = 150_000_000

// mock doesn't care about the url
let NON_EXISTANT_URL = "https://example.com/audio.mp3"

// suite for mocked player, use it for TDD
struct menuRadioTestsMock {
    
    @Test("RadioPlayer should be able to start playback")
    func createTestPlayerShouldReturnValidInstances() async {
        let player = RadioPlayer(audioPlayer: MockAudioPlayer())
        //let player = createTestPlayer(audioPlayer: MockAudioPlayer())
        var started = false
            player.onPlaybackStateChange = { isPlaying in
                if isPlaying { started = true }
            }

            player.play(url: NON_EXISTANT_URL)

            try? await Task.sleep(nanoseconds: TEST_ASYNC_WAIT)

            #expect(started)
            #expect(player.isPlaying)
    }
    
    
    @Test("RadioPlayer should stop playback and update state")
    func radioPlayerStopsPlayback() async {
        let player = RadioPlayer(audioPlayer: MockAudioPlayer())

        var stopped = false
        player.onPlaybackStateChange = { isPlaying in
            if !isPlaying { stopped = true }
        }

        player.play(url: NON_EXISTANT_URL)
        try? await Task.sleep(nanoseconds: TEST_ASYNC_WAIT)

        player.stop()
        try? await Task.sleep(nanoseconds: TEST_ASYNC_WAIT)

        #expect(stopped)
        #expect(!player.isPlaying)
    }

    @Test("RadioPlayer should stop previous playback before starting a new one")
    func radioPlayerStopsBeforeRestarting() async {
        let player = RadioPlayer(audioPlayer: MockAudioPlayer())

        var playCount = 0
        player.onPlaybackStateChange = { isPlaying in
            if isPlaying { playCount += 1 }
        }

        player.play(url: NON_EXISTANT_URL)
        try? await Task.sleep(nanoseconds: TEST_ASYNC_WAIT)

        player.play(url: NON_EXISTANT_URL)
        try? await Task.sleep(nanoseconds: TEST_ASYNC_WAIT)

        #expect(playCount == 2)
    }
}


