//
//  FoodManChuApp.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

@main
struct FoodManChuApp: App {
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 16)!)
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear() {
                    for family in UIFont.familyNames.sorted() {
                        let names = UIFont.fontNames(forFamilyName: family)
                        print("Family: \(family) Font names: \(names)")
                    }
                }
        }
    }
}
