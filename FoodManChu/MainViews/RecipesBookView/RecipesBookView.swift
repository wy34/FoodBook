//
//  RecipesBookview.swift
//  FoodManChu
//
//  Created by William Yeung on 3/5/21.
//

import SwiftUI

struct RecipesBookView: View {
    // MARK: - Properties
    @FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipeName, ascending: true)]) var recipes: FetchedResults<Recipe>
    @StateObject var recipeManager = RecipeManager()
        
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                if recipes.isEmpty {
                    HStack {
                        Spacer()
                        Text("No recipes. Add one in the Builder view or save one from the Discover page to enable convenient access here.")
                            .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .padding(.top, 35)
                        Spacer()
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.952141583, green: 0.9497230649, blue: 0.9704508185, alpha: 1)))
                } else {
                    ForEach(Array(groupsByFirstLetter().keys.sorted()), id: \.self) { key in
                        Section(header: Text(String(key)).font(.custom(FBFont.bold, size: 12, relativeTo: .body))) {
                            ForEach(groupsByFirstLetter()[key]!, id: \.id) { recipe in
                                NavigationLink(destination: BookRecipeDetailView(recipe: recipe, recipeManager: self.recipeManager)) {
                                    HStack {
                                        Text(recipe.recipeName ?? "")
                                            .font(.custom(FBFont.bold, size: 16, relativeTo: .body))
                                        Spacer()
                                        Text(recipe.category?.name ?? "")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 8)
                                            .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
                                            .background(Color.mainGreen)
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                            .onDelete(perform: { offsets in
                                self.delete(at: offsets, category: key)
                            })
                        }
                    }
                }
            }
                .navigationBarTitle("Recipe Book")
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Helpers
    private func groupsByFirstLetter() -> [Character: [Recipe]] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var recipeListGroupedByFirstLetter = [Character: [Recipe]]()
        
        for letter in alphabet {
            for recipe in self.recipes {
                if let firstLetter = recipe.recipeName?.first?.lowercased() {
                    if String(letter) == firstLetter {
                        if var recipeArr = recipeListGroupedByFirstLetter[letter] {
                            recipeArr.append(recipe)
                            recipeListGroupedByFirstLetter[letter] = recipeArr
                        } else {
                            recipeListGroupedByFirstLetter[letter] = [recipe]
                        }
                    }
                }
            }
        }
        
        return recipeListGroupedByFirstLetter
    }
    
    private func delete(at offsets: IndexSet, category: Character) {
        for offset in offsets {
            let recipe = groupsByFirstLetter()[category]![offset]
            PersistenceController.shared.delete(recipe)
            PersistenceController.shared.save()
        }
    }
}

