//
//  menuRadioApp.swift
//  menuRadio
//
//  Created by Vitaliy Sharovatov on 08.02.2025.
//

import SwiftUI

@main
struct menuRadioApp: App {
    private let player = RadioPlayer(audioPlayer: AVPlayerWrapper())
    
    init() {
        // no multiple instances
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: Bundle.main.bundleIdentifier ?? "")
        if runningApps.count > 1 {
            NSApplication.shared.terminate(nil)
        }
        
        player.play(url: "https://2.mystreaming.net:443/uber/crchopin/icecast.audio")

        // no need to show in the dock
        NSApplication.shared.setActivationPolicy(.prohibited)
    }
    
    var body: some Scene {
        MenuBarExtra("Radio", systemImage: "antenna.radiowaves.left.and.right") {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
