//
//  LottieView.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    var loopMode: LottieLoopMode = .playOnce
    var speed: CGFloat = 1.0

    final class Coordinator {
        var currentName: String?
        var animationView: LottieAnimationView?
    }
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.clipsToBounds = true

        let anim = LottieAnimationView(animation: LottieAnimation.named(name))
        anim.translatesAutoresizingMaskIntoConstraints = false
        anim.contentMode = .scaleAspectFit
        anim.loopMode = loopMode
        anim.animationSpeed = speed

        container.addSubview(anim)
        NSLayoutConstraint.activate([
            anim.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            anim.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            anim.topAnchor.constraint(equalTo: container.topAnchor),
            anim.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        anim.play()
        context.coordinator.currentName = name
        context.coordinator.animationView = anim
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let anim = context.coordinator.animationView else { return }
        if context.coordinator.currentName != name {
            anim.animation = LottieAnimation.named(name)
            context.coordinator.currentName = name
            anim.play()
        }
        anim.loopMode = loopMode
        anim.animationSpeed = speed
    }
}
