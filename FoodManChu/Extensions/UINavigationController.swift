//
//  UINavigationController.swift
//  FoodManChu
//
//  Created by William Yeung on 3/7/21.
//

import UIKit


// Hiding back button and replacing it with custom image breaks the navigation swipe to pop, this brings that back
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
