//
//  CustomSegmentedControl.swift
//  FoodManChu
//
//  Created by William Yeung on 3/2/21.
//

import SwiftUI

struct CustomSegmentedPickerWithMenu: View {
    @State private var selected = 0
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack(spacing: -10) {
                Button(action: { self.selected = 0 }) {
                    Text("Ingredients")
                        .padding()
                        .foregroundColor(self.selected == 0 ? Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)) : Color(#colorLiteral(red: 0.7019448876, green: 0.7045716047, blue: 0.7109025717, alpha: 1)))
                }
                
                Button(action: { self.selected = 1 }) {
                    Text("Directions")
                        .padding()
                        .foregroundColor(self.selected == 1 ? Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)) : Color(#colorLiteral(red: 0.7019448876, green: 0.7045716047, blue: 0.7109025717, alpha: 1)))
                }
            }
                .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                .animation(.easeIn)
                        
            if self.selected == 0 {
                PickerMenu(isIngredient: true, dataSource: ["Cheese", "Tomatoes", "Apples", "Beef", "Carrots", "Chicken", "Onions", "Bananas", "Broccoli", "Garlic", "Ginger", "Salt", "Pepper"])
            } else {
                PickerMenu(isIngredient: false, dataSource: ["Preheat Oven to 330", "Slice the Apples to thin pieces", "Make the gravy", "Peel the potatoes", "Thicken the gravy", "Add milk to sauce"])
            }
        }
        .animation(.easeIn)
    }
}


struct CustomSegmentedPickerWithMenu_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPickerWithMenu()
    }
}


// MARK: - PickerMenu
struct PickerMenu: View {
    var isIngredient: Bool
    var dataSource: [String]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0..<dataSource.count, id: \.self) { i in
                VStack {
                    HStack {
                        Image(systemName: self.isIngredient ? "house" : "chevron.right")
                        Text("\(dataSource[i])")
                            .font(.custom("TypoRoundLightDemo", size: 16, relativeTo: .body))
                        Spacer()
                        if isIngredient {
                            Text("2 cups")
                                .font(.custom("TypoRoundLightDemo", size: 12, relativeTo: .body))
                        }
                    }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)

                    if i != dataSource.count - 1 {
                        Divider()
                    }
                }
            }
        }
            .padding(.vertical, 8)
            .frame(width: 250, height: (dataSource.count > 5) ? 175 : CGFloat(dataSource.count) * 50)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.25), lineWidth: 1)
            )
    }
}
