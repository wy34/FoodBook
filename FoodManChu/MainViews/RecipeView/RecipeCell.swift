//
//  RecipeCell.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct RecipeCell: View {
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    var recipe: Recipe
    var category: Category
    
    @Binding var isEditing: Bool
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var modalManager: ModalManager
    @Environment(\.managedObjectContext) var moc

    // MARK: - Body
    var body: some View {
        VStack {
            ZStack {
                Button(action: {
                    self.recipeManager.recipe = self.recipe
                    self.modalManager.isRecipeDetailViewShowing = true
                }) {
                    Image(uiImage: UIImage(data: recipe.recipeThumbnail ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.width / 2 - 35, height: screenSize.height / 4)
                        .cornerRadius(20)
                }
                
                if self.isEditing {
                    RoundedRectangle(cornerRadius: 21)
                        .fill(Color.black.opacity(0.45))
                        .frame(width: screenSize.width / 2 - 35, height: screenSize.height / 4)
                        .overlay(
                           Button(action: {
                                self.recipeManager.recipe = self.recipe
                                self.setRecipeValuesToPublished()
                                self.recipeManager.isShowingAddRecipe = true
                           }) {
                            Image(systemName: SFSymbols.pencilCircle)
                                    .font(.system(.largeTitle, design: .rounded))
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                                    .padding(30)
                            }
                        )
                        .overlay(
                            HStack {
                                Button(action: {
                                    self.recipeManager.isShowingDeleteRecipeAlert = true
                                    self.recipeManager.recipe = self.recipe
                                }) {
                                    Image(systemName: SFSymbols.trash)
                                        .imageScale(.medium)
                                        .foregroundColor(.white)
                                        .padding(12)
                                }
                                    .background(RoundedButtonView(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], bgColor: #colorLiteral(red: 1, green: 0.4903432131, blue: 0.4654182792, alpha: 0.7518001152), cornerRadius: 20))
                            }
                            , alignment: .topLeading
                        )
                        .overlay(
                            Button(action: {
                                let recipeCopy = Recipe(context: moc)
                                recipeCopy.recipeName = self.recipe.recipeName
                                recipeCopy.recipeDescription = self.recipe.recipeDescription
                                recipeCopy.recipeThumbnail = self.recipe.recipeThumbnail
                                recipeCopy.category = self.recipe.category
                                recipeCopy.timeHours = self.recipe.timeHours
                                recipeCopy.timeMinutes = self.recipe.timeMinutes
                                recipeCopy.ingredients = self.recipe.ingredients
                                recipeCopy.instructions = self.recipe.instructions
                                PersistenceController.shared.save()
                            }) {
                                Image(systemName: SFSymbols.plusRect)
                                    .imageScale(.medium)
                                    .foregroundColor(.white)
                                    .padding(12)
                            }
                                .background(RoundedButtonView(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner], bgColor: #colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1), cornerRadius: 20))
                            , alignment: .topTrailing
                        )
                }
            }
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                .animation(.easeInOut)
                
            Text(recipe.recipeName ?? "")
                .multilineTextAlignment(.center)
                .font(.custom(FBFont.medium, size: 16, relativeTo: .body))
                .frame(width: screenSize.width / 2 - 35)
                .lineLimit(nil)
                .padding(.top, 3)
        }
            .fullScreenCover(isPresented: self.$recipeManager.isShowingAddRecipe, content: {
                AddEditRecipeView(recipeManager: self.recipeManager)
                    .environment(\.managedObjectContext, self.moc)
            })
            .alert(isPresented: $recipeManager.isShowingDeleteRecipeAlert) {
                Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this recipe?"), primaryButton: .cancel(), secondaryButton: .default(Text("Yes")) {
                        if let recipe = self.recipeManager.recipe {
                            PersistenceController.shared.delete(recipe)
                            PersistenceController.shared.save()
                        }
                    }
                )
            }
    }
    
    // MARK: - Helpers
    private func setRecipeValuesToPublished() {
        self.recipeManager.name = self.recipe.recipeName ?? ""
        self.recipeManager.description = self.recipe.recipeDescription ?? ""
        self.recipeManager.selectedImage = UIImage(data: self.recipe.recipeThumbnail ?? Data()) ?? UIImage()
        self.recipeManager.hours = self.recipe.timeHours
        self.recipeManager.minutes = self.recipe.timeMinutes
        
        if let ingredients = self.recipe.ingredients?.allObjects as? [Ingredient] {
            self.recipeManager.ingredients = ingredients
        }
        
        self.recipeManager.instructions = self.recipe.instructions ?? []
    }
}
