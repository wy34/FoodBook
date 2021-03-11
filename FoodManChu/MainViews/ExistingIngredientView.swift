//
//  ExistingIngredientView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/9/21.
//

import SwiftUI

struct ExistingIngredientView: View {
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var persistenceController: PersistenceController
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]) var ingredients: FetchedResults<Ingredient>
    @State private var amount = ""
    @State private var tappedIngredient: Ingredient?
    @State private var isShowingDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(Array(groupsByFirstLetter().keys.sorted()), id: \.self) { key in
                    Section(header: Text(String(key))) {
                        ForEach(groupsByFirstLetter()[key]!, id: \.self) { ingredient in
                            HStack {
                                // only showing default name view if this isn't tapped
                                if tappedIngredient != ingredient {
                                    HStack {
                                        Button(action: {
                                            self.tappedIngredient = ingredient
                                            // if ingredient is already added, and if we tap on that same ingredient again, show its current amount
                                            if let index = self.recipeManager.ingredients.firstIndex(of: ingredient) {
                                                self.amount = self.recipeManager.ingredients[index].amount ?? ""
                                            } else {
                                                self.amount = ""
                                            }
                                        }) {
                                            HStack {
                                                Text(ingredient.name ?? "")
                                                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                                                Spacer()
                                            }
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                        
                                        if self.recipeManager.ingredients.contains(ingredient) {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                                
                                // showing this if this ingredient is acutally tapped
                                if self.tappedIngredient == ingredient {
                                    HStack(spacing: 15) {
                                        TextField("Amount", text: $amount)
                                            .foregroundColor(.gray)
                                        HStack(spacing: 5) {
                                            Button(action: {
                                                if self.amount != "" {
                                                    // added the ingredient onto the recipe manager so that it shows in the underlying list
                                                    if let index = self.ingredients.firstIndex(of: self.tappedIngredient!) {
                                                        let ing = self.ingredients[index]
                                                        ing.amount = self.amount // setting it so that changing the amount will be reflected in the list since it techinically wont be added again (next line of code)
                                                        
                                                        if !self.recipeManager.ingredients.contains(ing) {
                                                            self.recipeManager.ingredients.append(ing)
                                                        }
                                                    }
                                                    self.tappedIngredient = nil
                                                    self.amount = ""
                                                }
                                            }) {
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
                                    }
                                        .buttonStyle(PlainButtonStyle())
                                        .foregroundColor(.white)
                                        .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                                }
                            }
                            .animation(.easeInOut)
                        }
                            .onDelete(perform: self.delete(at:))
                    }
                }
            }
                .navigationBarTitle("Ingredients List", displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: { self.isShowingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(self.ingredients.isEmpty ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color(#colorLiteral(red: 1, green: 0.4903432131, blue: 0.4654182792, alpha: 0.7518001152)))
                    }
                        .disabled(self.ingredients.isEmpty ? true : false)
                )
                .alert(isPresented: self.$isShowingDeleteAlert) {
                    Alert(title: Text("Delete All Ingredients"), message: Text("Are you sure you want to delete all of your ingredients?"), primaryButton: .default(Text("Yes")) {
                        self.persistenceController.deleteAllIngredients()
                        self.persistenceController.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .cancel())
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
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            self.persistenceController.delete(self.ingredients[offset])
            self.persistenceController.save()
        }
    }
}
