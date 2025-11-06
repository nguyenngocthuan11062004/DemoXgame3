//
//  ImageFillProgressBar.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 28/10/25.
//

import SwiftUI

struct ImageFillProgressBar: View {
    let imageName: String
    let height: CGFloat
    let borderColor: Color?
    @Binding var progress: CGFloat

    private var clamped: CGFloat { max(0, min(1, progress)) }

    var body: some View {
        GeometryReader { geo in
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width * clamped)
                .clipped()
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: height/2))
        .overlay(
            Group {
                if let borderColor {
                    RoundedRectangle(cornerRadius: height/2)
                        .stroke(borderColor, lineWidth: 2)
                }
            }
        )
        .animation(.easeInOut(duration: 1.5), value: progress)
    }
}
