//
//  PickerMenu.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct PickerMenu: View {
    // MARK: - Properties
    var ingredients: [Ingredient]?
    var instructions: [String]?
    @State private var hide = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if self.ingredients != nil {
                    ForEach(0..<ingredients!.count, id: \.self) { i in
                        IngredientDirectionsCell(ingredient: ingredients![i], direction: nil, dataSourceCount: ingredients!.count, index: i)
                    }
                } else {
                    ForEach(0..<instructions!.count, id: \.self) { i in
                        IngredientDirectionsCell(ingredient: nil, direction: instructions![i], dataSourceCount: instructions!.count, index: i)
                    }
                }
            }
                .padding(.top, 12)
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
}
