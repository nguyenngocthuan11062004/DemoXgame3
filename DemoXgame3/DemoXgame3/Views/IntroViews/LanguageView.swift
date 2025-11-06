//
//  LanguageView.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI

struct LanguageView: View {
    var onContinue: () -> Void = {}
    private let languages: [Language] = [
        .init(name: "English",    flagIcon: "ic_uk",      bgImage: "bg_uk"),
        .init(name: "Français",   flagIcon: "ic_france",  bgImage: "bg_france"),
        .init(name: "Deutsch",    flagIcon: "ic_german",  bgImage: "bg_german"),
        .init(name: "日本語",        flagIcon: "ic_japan",   bgImage: "bg_japan"),
        .init(name: "한국인",        flagIcon: "ic_korean",  bgImage: "bg_korean"),
        .init(name: "Italiano",   flagIcon: "ic_italy",   bgImage: "bg_italy"),
        .init(name: "Русский",    flagIcon: "ic_russian", bgImage: "bg_russia"),
        .init(name: "Tiếng Việt", flagIcon: "ic_vn",      bgImage: "bg_vn"),
    ]

    @State private var selectedName: String? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                gradient: Gradient(colors: [Color("#FFE4F9"), Color("#D0E6FF")]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                HStack {
                        Text("Language")
                            .font(.custom("Zain-Bold", size: 32))
                            .foregroundColor(Color("#4462A2"))
                        Spacer()
                        let isDisabled = (selectedName?.isEmpty ?? true)
                    NavigationLink("Next") {
                        IntroView(onFinish: {
                            onContinue()
                        })
                    }
                        .font(.custom("Zain-Bold", size: 24))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isDisabled ? Color.gray.opacity(0.35) : Color("#558BFF"))
                        )
                        .foregroundColor(.white)
                        .opacity(isDisabled ? 0.8 : 1.0)
                        .disabled(isDisabled)
                        .animation(.easeInOut(duration: 0.2), value: isDisabled)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(languages) { lang in
                            LanguageCell(
                                name: lang.name,
                                flagIcon: lang.flagIcon,
                                bgImage: lang.bgImage,
                                isSelected: selectedName == lang.name
                            )
                            .onTapGesture {
                                if selectedName == lang.name {
                                    selectedName = nil
                                } else {
                                    selectedName = lang.name
                                }
                            }

                        }
                    }
                    .padding(.top, 6)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

#Preview {
    LanguageView()
}
