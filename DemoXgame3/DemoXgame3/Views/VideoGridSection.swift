//
//  VideoGridSection.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

struct VideoItem: Identifiable {
    let id = UUID()
    let bg: String
    let hashtag: String
    let likes: String
}

struct VideoGridSection: View {
    var onSelect: (() -> Void)? = nil

    @State private var selectedChip = 0
    private let chips = ["Filter Quiz", "Filter Quiz", "Filter Quiz", "Filter Quiz"]

    private let items: [VideoItem] = (0..<8).map { _ in
        .init(bg: "testimg", hashtag: "#Status random", likes: "6.8M")
    }

    private let columns = 2
    private let hSpacing: CGFloat = 16
    private let sideInset: CGFloat = 16

    var body: some View {
        let screenW = UIScreen.main.bounds.width
        let colW = (screenW - (sideInset * 2) - hSpacing * CGFloat(columns - 1))

        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FFE8FF"), Color(hex: "#E9E7FF")],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(chips.indices, id: \.self) { i in
                                FilterChip(
                                    title: chips[i],
                                    isSelected: selectedChip == i
                                ) { selectedChip = i }
                            }
                        }
                        .padding(.horizontal, sideInset)
                        .padding(.top, 22)
                    }

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: hSpacing), count: columns),
                        spacing: 16
                    ) {
                        ForEach(items) { item in
                            let cellW = (colW / 2)
                            VideoViewCell(
                                background: item.bg,
                                hashtag: item.hashtag,
                                likes: item.likes,
                                width: cellW,
                                corner: 20
                            )
                            .contentShape(Rectangle())
                            .onTapGesture { onSelect?() }
                        }
                    }
                    .padding(.horizontal, sideInset)
                    .padding(.bottom, 16)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 28))
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

#Preview {
    VideoGridSection(onSelect: {})
}
