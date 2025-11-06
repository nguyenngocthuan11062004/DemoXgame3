//
//  CustomBottomBar.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

struct BarTab {
    let Icon: String
    let title: String
}


struct CustomBottomBar: View {
    @Binding var selectedIndex: Int
    let leftTab: BarTab
    let rightTab: BarTab
    let centerImageName: String
    var height: CGFloat = 80
    var centerDiameter: CGFloat = 80
    var onCenterTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: height)
                    .shadow(color: .black.opacity(0.08), radius: 8, y: -2)

                HStack {
                    TabButton(
                        icon: leftTab.Icon,
                        title: leftTab.title,
                        isActive: selectedIndex == 0
                    ) { selectedIndex = 0 }

                    Spacer(minLength: centerDiameter + 24)

                    TabButton(
                        icon: rightTab.Icon,
                        title: rightTab.title,
                        isActive: selectedIndex == 1
                    ) { selectedIndex = 1 }
                }
                .padding(.horizontal, 65)
                .frame(height: height)

                Button(action: {
                    onCenterTap() // Gọi callback khi người dùng tap vào nút trung tâm
                }) {
                    Image(centerImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: centerDiameter, height: centerDiameter)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                }
                .offset(y: -centerDiameter * 0.4)
                .buttonStyle(.plain)
            }

            GeometryReader { geo in
                Color.white
                    .frame(height: geo.safeAreaInsets.bottom)
                    .ignoresSafeArea(edges: .bottom)
            }
            .frame(height: 0)
        }
    }
}

private struct TabButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(isActive ? Color.blue : Color.gray.opacity(0.7))
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}
