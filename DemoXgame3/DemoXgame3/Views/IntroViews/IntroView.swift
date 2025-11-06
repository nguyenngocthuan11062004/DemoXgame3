//
//  IntroView.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI
import Lottie

struct IntroView: View {
    @State private var page = 0
    var onFinish: () -> Void = {}

    let introItems: [IntroModel] = [
        .init(lottieName: "anim_intro_1", title: "Hair Ranking",
              subtitle: "Which color tops your hair destiny? Try the filter and see your ranking surprise!"),
        .init(lottieName: "anim_intro_2", title: "Face Puzzle",
              subtitle: "What happens when your face gets a twist?"),
        .init(lottieName: "anim_intro_3", title: "Prediction",
              subtitle: "Curious about the future? Try the filter and see the surprise!")
    ]

    var body: some View {
        ZStack {
            TabView(selection: $page) {
                ForEach(Array(introItems.enumerated()), id: \.offset) { idx, item in
                    IntroItemView(item: item)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.85), value: page)
            .toolbar(.hidden, for: .navigationBar)

            VStack {
                Spacer()
                PageDots(count: introItems.count, index: page)
                    .padding(.bottom, 120)
            }
            .allowsHitTesting(false)
            .offset(y: -150)
            Button {
                if page < introItems.count - 1 {
                    withAnimation(.easeInOut) { page += 1 }
                } else {
                    onFinish()
                }
            } label: {
                Text(page == introItems.count - 1 ? "Started" : "Next")
                    .font(.custom("Zain-Bold", size: 20))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .background(Capsule().fill(Color("#558BFF")))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white)
            .offset(y: 350)
        }
    }
}

private struct PageDots: View {
    let count: Int
    let index: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { i in
                if i == index {
                    Capsule()
                        .frame(width: 18, height: 6)
                        .foregroundColor(Color("#558BFF"))
                        .animation(.easeInOut(duration: 0.2), value: index)
                } else {
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(Color.gray.opacity(0.35))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

#Preview {
    IntroView(onFinish: { print("Intro finished!") })
}
