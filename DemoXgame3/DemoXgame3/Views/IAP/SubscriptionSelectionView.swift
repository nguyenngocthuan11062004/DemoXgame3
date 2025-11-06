//
//  SubscriptionSelectionView.swift
//  DemoXgame3
//
//  Created by Thuận Nguyễn on 3/11/25.
//

import SwiftUI

struct PlanOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let price: String
    let subtitle: String?
    let isBest: Bool
}

struct SubscriptionSelectionView: View {
    @State private var selectedPlan: PlanOption?

    let plans: [PlanOption] = [
        .init(title: "Weekly",  price: "$4.89",  subtitle: nil, isBest: false),
        .init(title: "Yearly",  price: "$27.99", subtitle: "($0.53/Weekly)", isBest: true),
        .init(title: "Monthly", price: "$9.99",  subtitle: "($2.49/weekly)", isBest: false)
    ]
    init() {
        _selectedPlan = State(initialValue: plans.first)
    }
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 20) {
                ForEach(plans) { plan in
                    PlanCard(plan: plan, isSelected: selectedPlan == plan)
                        .onTapGesture { selectedPlan = plan }
                }
            }
            .padding(.horizontal, 16)

            Button(action: {
                // hành động khi nhấn
            }) {
                ZStack {
                    Image("bt_custom")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 64)

                    Image("btn_continue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 24)
                }
            }
            .frame(height: 64)
            .padding(.horizontal, 40)
            .padding(.top, 4)


            Text("Subscriptions will auto-renew at the selected frequency (weekly/monthly/yearly) until canceled.")
                .font(.custom("BeVietnamPro-Regular", size: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            HStack(spacing: 24) {
                Text("Terms of Use")
                Text("Restore")
                Text("Privacy Policy")
            }
            .font(.custom("BeVietnamPro-Regular", size: 13))
            .foregroundColor(.white)
        }
        .padding(.vertical, 32)
        .background(
            Color(hex: "#DD80C4")
                .clipShape(RoundedCorners(radius: 20, corners: [.topLeft, .topRight]))
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: -4)
        )
    }
}

// MARK: - Card View
struct PlanCard: View {
    let plan: PlanOption
    var isSelected: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Text(plan.title)
                    .font(.custom("Grandstander-Bold", size: 18))
                    .foregroundColor(.black)
                    .offset(x: -12, y: plan.isBest ? -7 : -18)

                Text(plan.price)
                    .font(.custom("Grandstander-Black", size: 36))
                    .foregroundColor(.black)

                if let subtitle = plan.subtitle {
                    Text(subtitle)
                        .font(.custom("BeVietnamPro-SemiBold", size: 12))
                        .foregroundColor(Color(hex: "#6D678C"))
                }
            }
            .frame(width: 110, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "#FFF8E3") : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color(hex: "#FFD54F") : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
            )
            .overlay(alignment: .topTrailing) {
                if plan.isBest {
                    ZStack {
                        Image("bg_bestoffer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 28)

                        Text("Best offer")
                            .font(.custom("Grandstander-SemiBold", size: 12))
                            .foregroundColor(.black)
                    }
                    .offset(x: -20, y: -12)
                }
            }
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#FFD54F"))
                        .background(Color.white.clipShape(Circle()))
                        .offset(x: -10, y: 10)
                }
            }
        }
        .scaleEffect(plan.isBest ? 1.12 : 1.0)
        .animation(.easeOut(duration: 0.25), value: plan.isBest)
    }
}



struct RoundedCorners: Shape {
    var radius: CGFloat = 25
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SubscriptionSelectionView()
}
