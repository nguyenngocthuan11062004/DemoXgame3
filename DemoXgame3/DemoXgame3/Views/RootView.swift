//
//  RootView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI

struct RootView: View {
    @State private var selectedIndex = 0
    @State private var showCamera = false
    @StateObject private var ui = UIState()

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if selectedIndex == 0 {
                    HomeView()
                } else if selectedIndex == 1 {
                    MyRecordView()
                }
            }
            .environmentObject(ui)
            .ignoresSafeArea(.keyboard)

            if !ui.hideBottomBar {
                CustomBottomBar(
                    selectedIndex: $selectedIndex,
                    leftTab: .init(Icon: "ic_house_on", title: "Home"),
                    rightTab: .init(Icon: "ic_myrecord_off", title: "My Record"),
                    centerImageName: "ic_camera",
                    onCenterTap: { showCamera = true }
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: ui.hideBottomBar)
    }
}

#Preview {
    RootView()
}
