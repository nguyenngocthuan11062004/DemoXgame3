//
//  HomeView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

struct HomeView: View {
    @State private var goTiktok = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Image("Banner")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipped()
                    .ignoresSafeArea(edges: .top)

                VStack(alignment: .leading) {
                    HStack {
                        Text("Filter Quiz")
                            .font(.custom("Zain-Bold", size: 32))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(.leading, 20)
                        Spacer()
                        HStack(spacing: 12) {
                            CircleIconButton(imageName: "ic_premium")
                            CircleIconButton(imageName: "ic_setting")
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 26)
                    .padding(.horizontal,22)

                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("PLAY NOW")
                                .font(.custom("Zain-Black", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 38)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "#558BFF"), Color(hex: "#F046FF")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                )
                                .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                    }
                    .padding(.top, 80)
                    .padding(.trailing, 30)

                    Spacer()

                    VideoGridSection(onSelect: { goTiktok = true })
                        .padding(.horizontal, 3)
                        .padding(.bottom, 65)
                }
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink("", isActive: $goTiktok) {
                    TikTokStyleVideoView()
                }
                .hidden()
            )
        }
    }
}

struct CircleIconButton: View {
    let imageName: String
    var body: some View {
        Button(action: {}) {
            Image(imageName)
        }
    }
}

#Preview {
    HomeView()
}
