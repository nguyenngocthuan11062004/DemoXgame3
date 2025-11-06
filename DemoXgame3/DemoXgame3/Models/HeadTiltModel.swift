//
//  HeadTiltModel.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 4/11/25.
//

import SwiftUI
import Combine

// MARK: - ViewModel: nội suy scale & trạng thái sticker
final class HeadTiltModel: ObservableObject {

    @Published var leftScale:  CGFloat = 1.0
    @Published var rightScale: CGFloat = 1.0

    @Published var targetLeft:  CGFloat = 1.0
    @Published var targetRight: CGFloat = 1.0

    @Published var showSticker: Bool = false
    @Published var stickerX: CGFloat = 0.5
    @Published var stickerY: CGFloat = 0.3
    @Published var stickerWidthFrac: CGFloat = 0.2
    @Published var stickerAngleRad: CGFloat = 0.0

    @Published var invertStickerRotation = true
    @Published var stickerAngleBias: CGFloat = 0

    private var displayLink: CADisplayLink?
    private var lastTS: CFTimeInterval?

    func startTicker() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stopTicker() {
        displayLink?.invalidate()
        displayLink = nil
        lastTS = nil
    }

    @objc private func tick(_ link: CADisplayLink) {
        let now = link.timestamp
        let dt = CGFloat(lastTS.map { now - $0 } ?? (1.0 / 60.0))
        lastTS = now

        let k: CGFloat = 0.20 * max(0.5, min(1.5, dt / (1.0 / 60.0)))
        leftScale  += (targetLeft  - leftScale)  * k
        rightScale += (targetRight - rightScale) * k
    }
}
