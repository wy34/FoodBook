//
//  CustomSegmentedControl.swift
//  FoodManChu
//
//  Created by William Yeung on 3/2/21.
//

import SwiftUI

struct CustomSegmentedPickerWithMenu: View {
    // MARK: - Properties
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
                        .minimumScaleFactor(0.5)
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

// MARK: - Previews
struct CustomSegmentedPickerWithMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPickerWithMenu(recipeManager: RecipeManager())
    }
}
