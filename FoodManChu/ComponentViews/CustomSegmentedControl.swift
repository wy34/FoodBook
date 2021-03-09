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
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: { self.selected = 0 }) {
                    Text("Ingredients")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(self.selected == 0 ? Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)) : Color(.clear))
                        .foregroundColor(self.selected == 0 ? Color(.white) : Color(#colorLiteral(red: 0.7019448876, green: 0.7045716047, blue: 0.7109025717, alpha: 1)))
                        .cornerRadius(10)
                }
                
                Button(action: { self.selected = 1 }) {
                    Text("Directions")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(self.selected == 1 ? Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)) : Color(.clear))
                        .foregroundColor(self.selected == 1 ? Color(.white) : Color(#colorLiteral(red: 0.7019448876, green: 0.7045716047, blue: 0.7109025717, alpha: 1)))
                        .cornerRadius(10)
                }
            }
                .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                .animation(.easeIn)
                .padding(.bottom, 7)
                        
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
    
    var body: some View {
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
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
//            .frame(width: 250, height: ingredients != nil ? CGFloat(ingredients!.count) * 50 : CGFloat(instructions!.count) * 50)
            .frame(width: 250, height: 175)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
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
