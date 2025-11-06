//
//  View + Extension.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 3/11/25.
//

import SwiftUI

// MARK: - Cấu trúc cho từng icon overlay
struct OverlayIcon: Identifiable {
    let id = UUID()
    let imageName: String
    var size: CGSize
    var offset: CGPoint
    var rotation: Angle = .degrees(0)
    var opacity: Double = 1.0
}

// MARK: - Extension để overlay icon lên bất kỳ view nào
extension View {
    func overlayIcons(_ icons: [OverlayIcon]) -> some View {
        ZStack {
            self
            ForEach(icons) { icon in
                Image(icon.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: icon.size.width, height: icon.size.height)
                    .rotationEffect(icon.rotation) // 🔥 xoay theo góc tùy chọn
                    .opacity(icon.opacity)
                    .offset(x: icon.offset.x, y: icon.offset.y)
            }
        }
    }
}
