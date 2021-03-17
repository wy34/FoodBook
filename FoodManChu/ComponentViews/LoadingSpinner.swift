//
//  LoadingSpinner.swift
//  FoodManChu
//
//  Created by William Yeung on 3/17/21.
//

import UIKit
import SwiftUI

struct LoadingSpinner: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}
