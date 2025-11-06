//
//  RootView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

private enum AppStage {
    case splash, language, main
}

/// Flow: Splash -> Language (push Intro) -> Main
struct RootView: View {
    @State private var stage: AppStage = .splash
    @StateObject private var ui = UIState()

    var body: some View {
        ZStack {
            switch stage {
            case .splash:
                SplashView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                stage = .language
                            }
                        }
                    }

            case .language:
                // LanguageView sẽ push IntroView; khi IntroView.onFinish() được gọi,
                // ta chuyển sang .main
                NavigationStack {
                    LanguageView(onContinue: {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            stage = .main
                        }
                    })
                }
                .transition(.opacity)

            case .main:
                MainRootView()
                    .environmentObject(ui)
                    .transition(.opacity)
            }
        }
    }
}


struct MainRootView: View {
    @State private var selectedIndex = 0
    @State private var showCamera = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Group {
                    if selectedIndex == 0 {
                        HomeView()
                    } else if selectedIndex == 1 {
                        MyRecordView()
                    }
                }
                .environmentObject(UIState())
                .ignoresSafeArea(.keyboard)

                CustomBottomBar(
                    selectedIndex: $selectedIndex,
                    leftTab: .init(Icon: "ic_house_on", title: "Home"),
                    rightTab: .init(Icon: "ic_myrecord_off", title: "My Record"),
                    centerImageName: "ic_camera",
                    onCenterTap: {
                        showCamera = true
                    }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))

                NavigationLink("", isActive: $showCamera) {
                    CameraView()
                }
                .hidden()
            }
        }
    }
}

#Preview {
    RootView()
}
