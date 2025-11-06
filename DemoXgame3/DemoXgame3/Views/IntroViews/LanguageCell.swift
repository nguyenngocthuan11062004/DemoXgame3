//
//  LanguageCell.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI

struct LanguageCell: View {
    let name: String
    let flagIcon: String
    let bgImage: String
    let isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Image(bgImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("#A9C4FF"), lineWidth: 2)
                    )
            }


            VStack {
                Image(flagIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 60)
                    .cornerRadius(12)
                    .shadow(radius: 2)
                Text(name)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : Color("#5E5E5E") )
                    .font(.custom("Inter18pt-Medium", size: 17))
            }
            .padding()
        }
        .frame(width: 167, height: 144)
    }
}

#Preview {
    VStack(spacing: 20) {
        LanguageCell(name: "English", flagIcon: "ic_uk", bgImage: "bg_uk", isSelected: true)
        LanguageCell(name: "Français", flagIcon: "ic_france", bgImage: "bg_france", isSelected: false)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
