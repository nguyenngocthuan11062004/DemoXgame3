//
//  OutlinedText.swift
//  DemoAppXgame
//
//  Created by Thuận Nguyễn on 29/10/25.
//

import SwiftUI
import UIKit

struct OutlinedText: UIViewRepresentable {
    let text: String
    let font: UIFont
    let fillColor: UIColor
    let strokeColor: UIColor
    let strokeWidth: CGFloat

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: fillColor,
            .strokeColor: strokeColor,
            .strokeWidth: -strokeWidth
        ]
        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
