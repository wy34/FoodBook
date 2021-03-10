//
//  ExistingIngredientView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/9/21.
//

import SwiftUI

struct ExistingIngredientView: View {
    @ObservedObject var recipeManager: RecipeManager
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]) var ingredients: FetchedResults<Ingredient>
    @State private var amount = ""
    @State private var tappedIngredient: Ingredient?
    
    var body: some View {
        Form {
            ForEach(Array(groupsByFirstLetter().keys.sorted()), id: \.self) { key in
                Section(header: Text(String(key))) {
                    ForEach(groupsByFirstLetter()[key]!, id: \.self) { ingredient in
                        HStack {
                            if tappedIngredient != ingredient {
                                Button(action: {
                                    self.tappedIngredient = ingredient
                                }) {
                                    HStack {
                                        Text(ingredient.name ?? "")
                                        Spacer()
                                    }
                                        .foregroundColor(.black)
                                }
                            }
                            
                            
                            if self.tappedIngredient == ingredient {
                                HStack {
                                    TextField("Amount", text: $amount)
                                    Button(action: { print("OK") }) {
                                        Text("OK")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal)
                                            .background(Color.green)
                                            .cornerRadius(10)
                                    }

                                    Button(action: {
                                        self.tappedIngredient = nil
                                        self.amount = ""
                                    }) {
                                        Text("Cancel")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal)
                                            .background(Color.red)
                                            .cornerRadius(10)
                                    }
                                }
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(.white)
                                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func groupsByFirstLetter() -> [Character: [Ingredient]] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var ingredientListGroupedByFirstLetter = [Character: [Ingredient]]()
        
        for letter in alphabet {
            for ing in self.ingredients {
                if let firstLetter = ing.name?.first?.lowercased() {
                    if String(letter) == firstLetter {
                        if var ingArr = ingredientListGroupedByFirstLetter[letter] {
                            ingArr.append(ing)
                            ingredientListGroupedByFirstLetter[letter] = ingArr
                        } else {
                            ingredientListGroupedByFirstLetter[letter] = [ing]
                        }
                    }
                }
            }
        }
        
        return ingredientListGroupedByFirstLetter
    }
}
