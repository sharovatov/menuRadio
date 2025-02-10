//
//  menuRadioE2ETests.swift
//  menuRadioE2ETests
//
//  Created by Vitaliy Sharovatov on 09.02.2025.
//

import Testing
import menuRadio

struct menuRadioE2ETests {
    
    @Test("AVPlayerWrapper should actually play real audio")
    func realPlayerStartsPlayback() async {
        let player = RadioPlayer(audioPlayer: AVPlayerWrapper())

        var started = false
        player.onPlaybackStateChange = { if $0 { started = true } }
        
        player.play(url: "https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3")

        try? await Task.sleep(nanoseconds: 5_000_000_000)  // 5 secs 

        #expect(started)
        #expect(player.isPlaying)
    }
}
