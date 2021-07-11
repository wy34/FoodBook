//
//  IngredientDirectionCell.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct IngredientDirectionsCell: View {
    // MARK: - Properties
    var ingredient: Ingredient?
    var direction: String?
    var dataSourceCount: Int
    var index: Int
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                if ingredient != nil {
                    Image(systemName: SFSymbols.chevronRight)
                }
                
                Text(ingredient != nil ? ingredient!.name! : direction!)
                    .font(.custom(FBFont.light, size: 16, relativeTo: .body))
                Spacer()
                
                if ingredient != nil {
                    Text(ingredient!.amount!)
                        .font(.custom(FBFont.light, size: 14, relativeTo: .body))
                }
            }
            
            if index != dataSourceCount - 1 {
                Divider()
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}
