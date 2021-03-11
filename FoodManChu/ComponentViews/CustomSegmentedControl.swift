//
//  CustomSegmentedControl.swift
//  FoodManChu
//
//  Created by William Yeung on 3/2/21.
//

import SwiftUI

struct CustomSegmentedPickerWithMenu: View {
    @State private var selected = 0
    @ObservedObject var recipeManager: RecipeManager
    
    @State private var pickerSelection = 0
    var selections = ["Ingredients", "Instructions"]
    
    // MARK: - Body
    var body: some View {
        VStack {
            Picker("", selection: $selected) {
                ForEach(0..<selections.count, id: \.self) { i in
                    Text(selections[i])
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .padding(5)
                .background(Color(#colorLiteral(red: 0.8968909383, green: 0.9103438258, blue: 0.9443851113, alpha: 1)))
                .cornerRadius(10)
            
            if self.selected == 0 {
                PickerMenu(ingredients: self.recipeManager.recipeIngredients)
            } else {
                PickerMenu(instructions: self.recipeManager.recipeInstructions)
            }
        }
            .animation(.easeInOut)
    }
}


struct CustomSegmentedPickerWithMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPickerWithMenu(recipeManager: RecipeManager())
    }
}

// MARK: - PickerMenu
struct PickerMenu: View {
    var ingredients: [Ingredient]?
    var instructions: [String]?
    @State private var hide = false
    
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
                .frame(maxWidth: .infinity, maxHeight: 175)
        }
    }
}


struct IngredientDirectionsCell: View {
    var ingredient: Ingredient?
    var direction: String?
    var dataSourceCount: Int
    var index: Int
    
    var body: some View {
        VStack {
            HStack {
                if ingredient != nil {
                    Image(systemName: "chevron.right")
                }
                
                Text(ingredient != nil ? ingredient!.name! : "\(index + 1).  " + direction!)
                Spacer()
                
                if ingredient != nil {
                    Text(ingredient!.amount!)
                        .font(.custom("TypoRoundLightDemo", size: 12, relativeTo: .body))
                }
            }
            
            if index != dataSourceCount - 1 {
                Divider()
                    .background(Color.black.opacity(0.2))
            }
        }
    }
}
