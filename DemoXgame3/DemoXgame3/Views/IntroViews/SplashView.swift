//
//  SplashView.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI

struct SplashView: View {
    @State private var progress: CGFloat = 0.0
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("#FFB8F0"),
                    Color("#8BC1FF")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            Image("Frame")
            VStack() {
                Spacer()
                Image("logo 1")
                    .padding(.top, 70)
                    .frame(maxHeight: .infinity, alignment: .top)
                Spacer()
                VStack(spacing: 10) {
                    Spacer()
                        .frame(height: 250)
                    OutlinedText(
                        text: "New filter will update weekly",
                        font: UIFont(name: "Zain-Bold", size: 26) ?? .boldSystemFont(ofSize: 26),
                        fillColor: .white,
                        strokeColor: UIColor(Color("#5455D3")),
                        strokeWidth: 5
                    )
                    ImageFillProgressBar(
                        imageName: "loading",
                        height: 20,
                        borderColor: Color("#5455D3"),
                        progress: $progress
                    )
                    .frame(width: 280)
                }
                .padding(.bottom, 90)
            }
        }.onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                progress = 1.0
            }
        }
    }
}
#Preview {
    SplashView()
}
