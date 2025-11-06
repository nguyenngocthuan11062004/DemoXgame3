//
//  ReviewCardView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 3/11/25.
//

import SwiftUI

struct ReviewCard: Identifiable {
    let id = UUID()
    let user: String
    let text: String
    let rating: Int
}

struct ReviewCardView: View {
    let review: ReviewCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.user)
                .font(.custom("BeVietnamPro-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#FF4696"))

            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { i in
                    Image(i < review.rating ? "star" : "star_off")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
            }

            Text(review.text)
                .font(.custom("BeVietnamPro-Bold", size: 12))
                .foregroundColor(Color(hex: "#FF4696"))
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(width: 280, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F4AEF4"))
                .opacity(0.35)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
    }
}
struct ReviewScrollSection: View {
    let reviews: [ReviewCard] = [
        .init(user: "User name", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", rating: 5),
        .init(user: "User name", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", rating: 5),
        .init(user: "User name", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", rating: 5)
    ]

    @State private var currentIndex: Int = 0

    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { geo in
                let viewportW = geo.size.width
                let cardW = min(280.0, viewportW * 0.82)
                let spacing: CGFloat = 16
                let sideInset = 20.0

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: spacing) {
                        ForEach(reviews.indices, id: \.self) { idx in
                            ReviewCardView(review: reviews[idx])
                                .frame(width: cardW)
                                .background(
                                    GeometryReader { inner in
                                        Color.clear
                                            .preference(
                                                key: CenterDistanceKey.self,
                                                value: [
                                                    CenterDistance(
                                                        index: idx,
                                                        distance: abs(
                                                            (inner.frame(in: .global).midX) -
                                                            (geo.frame(in: .global).midX)
                                                        )
                                                    )
                                                ]
                                            )
                                    }
                                )
                        }
                    }
                    .padding(.horizontal, sideInset)
                }
                .onPreferenceChange(CenterDistanceKey.self) { values in
                    if let nearest = values.min(by: { $0.distance < $1.distance }) {
                        currentIndex = nearest.index
                    }
                }
            }
            .frame(height: 150)

            PageDots(count: reviews.count, index: currentIndex)
        }
    }
}

private struct CenterDistance: Equatable {
    let index: Int
    let distance: CGFloat
}

private struct CenterDistanceKey: PreferenceKey {
    static var defaultValue: [CenterDistance] = []
    static func reduce(value: inout [CenterDistance], nextValue: () -> [CenterDistance]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PageDots: View {
    let count: Int
    let index: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { i in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(i == index ? Color(hex: "#FF4DCD") : Color.gray.opacity(0.35))
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(i == index ? 0.9 : 0), lineWidth: 1)
                    )
            }
        }
        .animation(.easeInOut(duration: 0.2), value: index)
        .padding(.top, 2)
    }
}

#Preview {
    ReviewScrollSection()
}
