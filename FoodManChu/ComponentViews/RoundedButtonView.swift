//
//  RoundedButtonView.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct RoundedButtonView: UIViewRepresentable {
    // MARK: - Properties
    var corners: CACornerMask
    var bgColor: UIColor
    var cornerRadius: CGFloat
    
    // MARK: - Helpers
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = corners
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
