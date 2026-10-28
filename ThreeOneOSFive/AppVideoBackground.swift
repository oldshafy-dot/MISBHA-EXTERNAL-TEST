import SwiftUI
import AVFoundation
import AVKit

/// Full-screen looping background video. The source clip includes an audio track.
struct AppVideoBackground: View {
    var body: some View {
        LoopingVideoPlayer()
            .ignoresSafeArea()
            
            .allowsHitTesting(false)
    }
}

private struct LoopingVideoPlayer: UIViewRepresentable {
    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()
        view.playerLayer.videoGravity = .resizeAspectFill
        if let url = Bundle.main.url(forResource: "MISBAH_Background", withExtension: "mp4") {
            let player = AVQueuePlayer()
            player.isMuted = false
            player.volume = 1.0
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
            try? AVAudioSession.sharedInstance().setActive(true)
            let item = AVPlayerItem(url: url)
            let looper = AVPlayerLooper(player: player, templateItem: item)
            context.coordinator.player = player
            context.coordinator.looper = looper
            view.playerLayer.player = player
            player.play()
        }
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        if let player = context.coordinator.player, player.timeControlStatus != .playing {
            player.play()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
    }

    final class PlayerView: UIView {
        override class var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    }
}
