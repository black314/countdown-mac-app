import Foundation
import AVFoundation

actor SoundManager {
    static let shared = SoundManager()
    
    private var players: [String: AVAudioPlayer] = [:]
    
    private init() {
        Task {
            await preloadSounds()
        }
    }
    
    private func preloadSounds() {
        // Default built-in sounds
        let sounds = [
            "Default": "timer-default",
            "Subtle": "timer-subtle",
            "Loud": "timer-loud",
            "Gentle": "timer-gentle",
            "Bell": "hotel-bell-ding" // Added hotel-bell-ding sound
        ]
        
        for (name, resource) in sounds {
            // Try to load with wav extension first
            if let url = Bundle.main.url(forResource: resource, withExtension: "wav") {
                loadSound(name: name, url: url)
            }
            // Try mp3 extension if wav is not found
            else if let url = Bundle.main.url(forResource: resource, withExtension: "mp3") {
                loadSound(name: name, url: url)
            }
            else {
                print("Sound file not found: \(resource).wav or \(resource).mp3")
            }
        }
    }
    
    private func loadSound(name: String, url: URL) {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            players[name] = player
        } catch {
            print("Could not load sound \(name): \(error)")
        }
    }
    
    func play(sound: String) {
        guard let player = players[sound] else {
            print("Sound not found: \(sound)")
            return
        }
        
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        
        // 👇 核心修改在这里：设置为 2，代表除了原本的 1 次外，再额外循环 2 次（共计 3 次）
        player.numberOfLoops = 2
        
        player.play()
    }
    
    func getAllSoundNames() -> [String] {
        return Array(players.keys).sorted()
    }
    
    // For adding custom sounds later
    func addCustomSound(name: String, url: URL) {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            players[name] = player
        } catch {
            print("Could not add custom sound \(name): \(error)")
        }
    }
}
