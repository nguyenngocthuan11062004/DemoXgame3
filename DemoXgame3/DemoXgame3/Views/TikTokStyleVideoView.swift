//
//  TikTokStyleVideoView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 30/10/25.
//

import SwiftUI
import AVKit

struct TTVideoItem: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let creator: String
    let likes: Int
}

struct TikTokStyleVideoView: View {
    @EnvironmentObject private var ui: UIState
    @Environment(\.dismiss) private var dismiss
    private let items: [TTVideoItem] = {
        var arr: [TTVideoItem] = []
        if let u1 = Bundle.main.url(forResource: "videotest1", withExtension: "mp4") {
            arr.append(.init(url: u1, title: "#Lockcode_Challenge", creator: "@Turtle", likes: 24000))
        }
        if let u2 = Bundle.main.url(forResource: "videotest2", withExtension: "mp4") {
            arr.append(.init(url: u2, title: "#Summer_Vibes", creator: "@Luna", likes: 12500))
        }
        if let u3 = Bundle.main.url(forResource: "videotest3", withExtension: "mp4") {
            arr.append(.init(url: u3, title: "#StreetDance", creator: "@Neo", likes: 5800))
        }
        if let u4 = Bundle.main.url(forResource: "videotest4", withExtension: "mp4") {
            arr.append(.init(url: u4, title: "#StreetDance", creator: "@Neo", likes: 5800))
        }
        if let u5 = Bundle.main.url(forResource: "videotest5", withExtension: "mp4") {
            arr.append(.init(url: u5, title: "#StreetDance", creator: "@Neo", likes: 5800))
        }
        if let u6 = Bundle.main.url(forResource: "videotest6", withExtension: "mp4") {
            arr.append(.init(url: u6, title: "#StreetDance", creator: "@Neo", likes: 5800))
        }
        
        return arr
    }()
    
    @State private var currentIndex: Int? = 0
    
    var body: some View {
        let pageW = UIScreen.main.bounds.width
        let pageH = UIScreen.main.bounds.height
        
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    TikTokVideoCell(
                        item: item,
                        isActive: currentIndex == idx,
                        onBack: { dismiss() },
                        onPlayNow: {}
                    )
                    .frame(width: pageW, height: pageH)
                    .contentShape(Rectangle())
                    .clipped()
                    .id(idx)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $currentIndex)
        .scrollIndicators(.hidden)
        .ignoresSafeArea()
        .background(Color.black)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { ui.hideBottomBar = true }
        .onDisappear { ui.hideBottomBar = false }
    }
  }


struct PlayerLayerView: UIViewRepresentable {
    let player: AVPlayer
    var fit: Bool = true

    func makeUIView(context: Context) -> PlayerView {
        let v = PlayerView()
        v.clipsToBounds = true
        v.player = player
        v.playerLayer.videoGravity = fit ? .resizeAspect : .resizeAspectFill
        return v
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {
        if uiView.player !== player {
            uiView.player = player
        }
        uiView.playerLayer.videoGravity = fit ? .resizeAspect : .resizeAspectFill
    }

    final class PlayerView: UIView {
        override static var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
        var player: AVPlayer? {
            get { playerLayer.player }
            set { playerLayer.player = newValue }
        }
    }
}

struct TikTokVideoCell: View {
    let item: TTVideoItem
    var isActive: Bool = true
    var onBack: (() -> Void)? = nil
    var onPlayNow: (() -> Void)? = nil

    @State private var player: AVPlayer?
    @State private var liked = false
    @State private var showPauseIcon = false

    var body: some View {
        ZStack {
            if let player {
                PlayerLayerView(player: player, fit: true)
                    .onAppear {
                        setupLoop(for: player)
                        isActive ? player.play() : player.pause()
                    }
                    .onDisappear { player.pause() }
                    .onChange(of: isActive) { _, active in
                        active ? player.play() : player.pause()
                    }
            } else {
                ProgressView().tint(.white)
                    .task { player = AVPlayer(url: item.url) }
            }

            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .onTapGesture { togglePlay() }
                .allowsHitTesting(isActive)

            if showPauseIcon {
                Image(systemName: "play.fill")
                    .font(.system(size: 40, weight: .regular))
                    .foregroundStyle(.white)
                    .shadow(radius: 6)
                    .transition(.scale.combined(with: .opacity))
            }

            if isActive {
                VStack {
                    HStack {
                        Button(action: { onBack?() }) {
                            Image("ic_back")
                                .frame(width: 36, height: 36)
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(radius: 2, y: 1)
                        }
                        .padding(.leading, 12)
                        .padding(.top, 70)
                        Spacer()
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.35), .black.opacity(0.8)],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 220)
                    .overlay(
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.system(size: 22, weight: .semibold))
                                        .foregroundColor(.white)
                                        .shadow(radius: 2)
                                    Text("Created by \(item.creator)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                Spacer()
                                VStack(spacing: 6) {
                                    Button(action: { liked.toggle() }) {
                                        Image(systemName: liked ? "heart.fill" : "heart")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    Text(formatLikes(item.likes + (liked ? 1 : 0)))
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.95))
                                }
                            }
                            Button(action: { onPlayNow?() }) {
                                Text("Play Now")
                                    .font(.custom("Zain-Bold", size: 26))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 52)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(hex: "#FF5555"))
                                    )
                            }
                            .padding(.top, 2)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 60),
                        alignment: .bottom
                    )
                }
            }
        }
        .background(Color.black)
        .clipped()
    }

    private func togglePlay() {
        guard let player else { return }
        switch player.timeControlStatus {
        case .playing:
            player.pause()
            withAnimation(.easeOut(duration: 0.15)) { showPauseIcon = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeIn(duration: 0.2)) { showPauseIcon = false }
            }
        default:
            player.play()
            withAnimation(.easeOut(duration: 0.1)) { showPauseIcon = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeIn(duration: 0.15)) { showPauseIcon = false }
            }
        }
    }

    private func setupLoop(for p: AVPlayer) {
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: p.currentItem,
            queue: .main
        ) { _ in
            p.seek(to: .zero)
            p.play()
        }
    }

    private func formatLikes(_ n: Int) -> String {
        if n >= 1_000_000 { return String(format: "%.1fM", Double(n)/1_000_000) }
        if n >= 1_000 { return String(format: "%.0fK", Double(n)/1_000) }
        return "\(n)"
    }
}
