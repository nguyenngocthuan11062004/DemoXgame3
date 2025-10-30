//
//  PlayerView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 30/10/25.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerContainer {
        let v = PlayerContainer()
        v.backgroundColor = .black
        v.playerLayer.player = player
        v.playerLayer.videoGravity = .resizeAspectFill

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.didEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        context.coordinator.player = player
        return v
    }

    func updateUIView(_ uiView: PlayerContainer, context: Context) {
        uiView.playerLayer.player = player
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject {
        weak var player: AVPlayer?

        @objc func didEnd() {
            player?.seek(to: .zero)
            player?.play()
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }

    final class PlayerContainer: UIView {
        override static var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .black
            clipsToBounds = true
        }
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            backgroundColor = .black
            clipsToBounds = true
        }
    }
}
