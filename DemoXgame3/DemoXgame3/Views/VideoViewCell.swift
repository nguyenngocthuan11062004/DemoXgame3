//
//  VideoViewCell.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

struct VideoViewCell: View {
    let background: String
    let hashtag: String
    let likes: String
    
    var width: CGFloat = 180
    var corner: CGFloat = 20
    
    var body: some View {
        let height = width * 1.35
        
        ZStack(alignment: .bottomLeading) {
            Image(background)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: corner))
            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.55)],
                startPoint: .center, endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: corner))
            VStack(alignment: .leading, spacing: 0) {
                Text(hashtag)
                    .font(.custom("Zain-Regular", size: 18))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                HStack(spacing: 3) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text(likes)
                        .font(.custom("Zain-Regular", size: 15))
                }
                .foregroundColor(.white)
            }
            .padding(12)
        }
        .frame(width: width, height: height)
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(Color(hex: "#A9C4FF"), lineWidth: 4)
        )
        .background(
            RoundedRectangle(cornerRadius: corner + 8)
                .fill(Color(hex: "#EFDFFF"))
        )
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    VideoViewCell(
        background: "testimg",
        hashtag: "#Status random",
        likes: "6.8M"
    )
}
