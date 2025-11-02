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
    private let headerHeight: CGFloat = 56

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FFE8FF"), Color(hex: "#E9E7FF")],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: hSpacing), count: columns),
                            spacing: 16
                        ) {
                            let colWidth = (geo.size.width - (sideInset * 2) - hSpacing * CGFloat(columns - 1)) / CGFloat(columns)
                            ForEach(items) { item in
                                VideoViewCell(
                                    background: item.bg,
                                    hashtag: item.hashtag,
                                    likes: item.likes,
                                    width: colWidth,
                                    corner: 20
                                )
                                .contentShape(Rectangle())
                                .onTapGesture { onSelect?() }
                            }
                        }
                        .padding(.horizontal, sideInset)

                        Spacer(minLength: 8)
                    }
                    .padding(.top, headerHeight + 16)
                    .padding(.bottom, 16)
                }
                .clipShape(RoundedRectangle(cornerRadius: 28))
            }
        }

        .overlay(alignment: .top) {
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
                .frame(height: headerHeight)
                .padding(.vertical, 6)
            }

            .background(
                Color(hex: "#FFE8FF")
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
            )
            .padding(.horizontal, 0)
            .padding(.top, 0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


#Preview {
    VideoGridSection(onSelect: {})
}
