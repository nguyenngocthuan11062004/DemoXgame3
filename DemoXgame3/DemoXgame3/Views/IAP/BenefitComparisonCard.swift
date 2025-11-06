//
//  BenefitComparisonCard.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 3/11/25.
//

import SwiftUI

struct BenefitRow: Identifiable {
    let id = UUID()
    let iconName: String
    let title: String
    let freeIncluded: Bool
    let premiumIncluded: Bool
}

struct BenefitComparisonCard: View {
    let rows: [BenefitRow]
    

    private let outerRadius: CGFloat = 16
    private let inset: CGFloat = 16
    private var innerRadius: CGFloat { 12 }

    var outerColor = Color(hex: "#F4AEF4")
    var bgColor     = Color.white.opacity(0.35)
    var borderColor = Color.white.opacity(0.55)
    var bandColor   = Color.white.opacity(0.25)
    var titleColor  = Color(hex: "#FF006F")

    var body: some View {
        let innerShape = RoundedRectangle(cornerRadius: innerRadius, style: .continuous)
        let bodyContent =
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text("Free")
                    .font(.custom("BeVietnamPro-SemiBold", size: 14))
                    .foregroundColor(Color(hex: "#838383").opacity(0.85))
                Image("banner_premium")
                    .resizable().scaledToFit()
                    .frame(width: 90, height: 28)
                    .padding(.leading, 6)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            ForEach(Array(rows.enumerated()), id: \.offset) { idx, row in
                HStack(spacing: 12) {
                    HStack(spacing: 10) {
                        Image(row.iconName)
                            .resizable().scaledToFit()
                            .frame(width: 18, height: 18)
                        Text(row.title)
                            .font(.custom("BeVietnamPro-SemiBold", size: 14))
                            .foregroundColor(titleColor)
                            .frame(maxWidth: 140, alignment: .leading)
                            .lineLimit(2)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    (row.freeIncluded ? AnyView(
                        Image("ic_heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .offset(x: -75)
                    ) : AnyView(Color.clear.frame(width: 20, height: 20)))

                    (row.premiumIncluded ? AnyView(
                        Image("ic_heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .offset(x: -40)
                    ) : AnyView(Color.clear.frame(width: 20, height: 20)))

                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(idx.isMultiple(of: 2) ? bandColor : .clear)
            }
        }
        .background(innerShape.fill(bgColor))
        .clipShape(innerShape)
        .overlay(innerShape.stroke(borderColor, lineWidth: 1))
        .padding(.horizontal, 10)
        .padding(.vertical, inset)
        .fixedSize(horizontal: false, vertical: true)
        return bodyContent
            .background(
                RoundedRectangle(cornerRadius: outerRadius)
                    .fill(outerColor)
                    .shadow(color: .white.opacity(0.18), radius: 1, y: 0.5)
            )
    }
}

struct BenefitComparisonCard_Preview: View {
    var body: some View {
        BenefitComparisonCard(
            rows: [
                .init(iconName: "ic_record", title: "Record with random filters", freeIncluded: true,  premiumIncluded: true),
                .init(iconName: "ic_noad",    title: "No ads",                    freeIncluded: false, premiumIncluded: true),
                .init(iconName: "ic_gun",     title: "Unlock all newest trending filters", freeIncluded: false, premiumIncluded: true)
            ]
        )
        .frame(maxWidth: 360)
        .padding()
    }
}

#Preview { BenefitComparisonCard_Preview() }
