//
//  FilterChip.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

 struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Zain-Regular", size: 20))
                .foregroundColor(isSelected ? .black : .white.opacity(0.9))
                .padding(.horizontal, 24)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(
                        isSelected
                        ? Color.white
                        : Color.black.opacity(0.15)
                    )
                )
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    VStack(spacing: 20) {
        FilterChip(title: "Filter Quiz", isSelected: true, action: {})
        FilterChip(title: "Filter Quiz", isSelected: false, action: {})
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}


