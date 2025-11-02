import SwiftUI
import RealmSwift

struct MyRecordView: View {
    @ObservedResults(VideoEntity.self) var videos
    @State private var goTikTok = false
    @State private var selectedIndexes: Set<Int> = []
    @State private var selectedChip = 0
    private let chips = ["Filter Quiz", "Filter Quiz", "Filter Quiz", "Filter Quiz"]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#FFE8FF"), Color(hex: "#E9E7FF")],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Image("Logo")
                            .padding(.leading, 16)
                        Spacer()
                        HStack(spacing: 12) {
                            CircleIconButton(imageName: "ic_premium")
                            CircleIconButton(imageName: "ic_setting")
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, 12)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(chips.indices, id: \.self) { i in
                                FilterChip(
                                    title: chips[i],
                                    isSelected: selectedChip == i
                                ) { selectedChip = i }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(videos.freeze()) { v in
                                Button {
                                    withAnimation(.easeInOut) { goTikTok = true }
                                } label: {
                                    VideoViewCell(
                                        background: v.background,
                                        hashtag: v.hashtag,
                                        likes: v.likes.abbreviated,
                                        width: (UIScreen.main.bounds.width - 40 - 16) / 2
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 220)
                    }

                    Spacer(minLength: 0)

                    HStack(spacing: 24) {
                        Button(action: playGame) {
                            Text("Play Game")
                                .font(.custom("Zain-Bold", size: 20))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color(hex: "#558BFF"))
                                )
                                .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                        }

                        Button(role: .destructive, action: deleteAll) {
                            Text("Delete All")
                                .font(.custom("Zain-Bold", size: 18))
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.red)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                        }
                    }
                    .padding(.bottom, 90)
                }

                if videos.isEmpty {
                    VStack(spacing: 12) {
                        Image("img_cat")
                            .transition(.opacity)
                            .allowsHitTesting(false)
                        Text("Press Play Game to add the first record!")
                            .font(.custom("Zain-Regular", size: 18))
                            .foregroundColor(Color(hex: "#5455D3"))
                    }
                    .offset(y: -60)
                }
            }
            .navigationDestination(isPresented: $goTikTok) {
                TikTokStyleVideoView()
            }
        }
    }

    private func playGame() {
        let tag = "Filter Quiz"
        let obj = VideoEntity(background: "testimg", hashtag: "#Status random", likes: Int.random(in: 1_000...2_000_000))
        withAnimation(.easeInOut) { $videos.append(obj) }

        let newIndex = max(chips.count - 1, 0)
        selectedIndexes.insert(newIndex)
    }

    private func deleteAll() {
        withAnimation(.easeInOut) {
            let all = IndexSet(videos.indices)
            $videos.remove(atOffsets: all)
            selectedIndexes.removeAll()
        }
    }

    private func toggleChip(at index: Int) {
        if selectedIndexes.contains(index) { selectedIndexes.remove(index) }
        else { selectedIndexes.insert(index) }
    }
}

private extension Int {
    var abbreviated: String {
        if self >= 1_000_000 {
            return String(format: "%.1fM", Double(self) / 1_000_000)
                .replacingOccurrences(of: ".0", with: "")
        } else if self >= 1_000 {
            return String(format: "%.1fK", Double(self) / 1_000)
                .replacingOccurrences(of: ".0", with: "")
        } else { return "\(self)" }
    }
}
#Preview {
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "PreviewRealm"))
    try! realm.write {
        realm.deleteAll()
        for i in 0..<6 {
            let v = VideoEntity()
            v.background = "testimg"
            v.hashtag = "#Tag\(i)"
            v.likes = Int.random(in: 5000...150000)
            realm.add(v)
        }
    }

    return MyRecordView()
        .environment(\.realm, realm)
}
