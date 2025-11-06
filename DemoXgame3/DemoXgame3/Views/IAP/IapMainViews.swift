//
//  IapMainViews.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 3/11/25.
//

import SwiftUI

struct IapMainViews: View {
    @Environment(\.dismiss) private var dismiss   // dùng để đóng fullScreenCover

    private let bottomSheetHeight: CGFloat = 260

    var body: some View {
        ZStack(alignment: .topLeading) {
            ZStack(alignment: .bottom) {

                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(hex: "#EEAFEF"), location: 0.3),
                                .init(color: Color.white,           location: 0.4)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(minHeight: UIScreen.main.bounds.height)

                        ZStack {
                            Image("frame_iap")
                                .opacity(1)
                                .offset(y: -300)

                            ZStack {
                                Image("girl")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 180)

                                Image("ic_1")
                                    .frame(width: 46, height: 53)
                                    .offset(x: -110, y: -75)
//ok
                                Image("ic_4")
                                    .frame(width: 40, height: 40)
                                    .offset(x: -130, y: 20)

                                Image("ic_5")
                                    .frame(width: 44, height: 44)
                                    .offset(x: 80, y: -100)

                                Image("ic_3")
                                    .frame(width: 54, height: 64)
                                    .rotationEffect(.degrees(0))
                                    .offset(x: 140, y: -30)

                                Image("ic_2")
                                    .frame(width: 44, height: 44)
                                    .rotationEffect(.degrees(5))
                                    .offset(x: 160, y: 60)
                            }
                            .offset(y: -260)

                            Image("premium")
                                .frame(width: 160, height: 160)
                                .offset(y: -170)

                            OutlinedText(
                                text: "Upgrade Beauty",
                                font: UIFont(name: "Grandstander-Black", size: 24) ?? .boldSystemFont(ofSize: 26),
                                fillColor: .white,
                                strokeColor: UIColor(Color(hex: "#81AAEC")),
                                strokeWidth: 5
                            )
                            .shadow(color: Color(hex: "#2E5ABD").opacity(0.9), radius: 0, x: 2, y: 2)
                            .frame(height: 40)
                            .offset(y: -110)
                        }

                        ReviewScrollSection()

                        Image("benefit")
                            .offset(y: 110)

                        BenefitComparisonCard(
                            rows: [
                                .init(iconName: "ic_record", title: "Record with random filters", freeIncluded: true,  premiumIncluded: true),
                                .init(iconName: "ic_noad",    title: "No ads",                    freeIncluded: false, premiumIncluded: true),
                                .init(iconName: "ic_gun",     title: "Unlock all newest trending filters", freeIncluded: false, premiumIncluded: true)
                            ]
                        )
                        .frame(maxWidth: 360)
                        .padding()
                        .offset(y: 270)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, bottomSheetHeight + 100)
                }
                .ignoresSafeArea(edges: .top)

                SubscriptionSelectionView()
                    .ignoresSafeArea(edges: .bottom)
            }

            Button(action: {
                dismiss()
            }) {
                Image("btn_close")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .padding(.top, 44)
            .padding(.leading, 20)
        }
    }
}

#Preview {
    IapMainViews()
}
