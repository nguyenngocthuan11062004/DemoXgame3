//
//  IntroItemView.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI
import Lottie
struct IntroItemView: View {
    let item: IntroModel
    
    var body: some View {
        VStack {
            LottieView(name: item.lottieName, loopMode: .loop, speed: 1.0)
                .frame(height: UIScreen.main.bounds.height / 2)
                .edgesIgnoringSafeArea(.top)
            Text(item.title)
                .font(.custom("Zain-Bold", size: 24))
            Text(item.subtitle)
                .font(.custom("Inter18pt-Regular", size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
    }
}
