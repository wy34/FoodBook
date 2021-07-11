//
//  RecipeGrid.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct RecipeGrid: View {
    // MARK: - Properties
    var category: Category
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200), spacing: 15), count: 2)
    let screenSize = UIScreen.main.bounds
    let recipes: FetchRequest<Recipe>

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modalManager: ModalManager
    @Binding var isEditing: Bool
    @State private var searchText = ""
    @ObservedObject var recipeManager: RecipeManager

    // MARK: - Init
    init(category: Category, isEditing: Binding<Bool>, recipeManager: RecipeManager) {
        self.category = category
        _isEditing = isEditing
        self.recipeManager = recipeManager
        self.recipes = FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipeName, ascending: true)], predicate: NSPredicate(format: "category.name MATCHES %@",  category.name ?? ""))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                ScrollView(showsIndicators: false) {
                    SearchBar(placeholder: "Search Recipes", searchText: $searchText)
                        .padding(.top, 15)
                        .padding(.horizontal, 5)
                    
                    if self.recipes.wrappedValue.isEmpty {
                        Text("No \(category.name ?? "") recipes. Press the green plus button to start adding one.")
                            .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .padding(.top, 75)
                    } else {
                        LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                            ForEach(recipes.wrappedValue.filter({ $0.recipeName!.lowercased().contains(searchText.lowercased()) || searchText.isEmpty }), id: \.self) { recipe in
                                RecipeCell(recipe: recipe, category: self.category, isEditing: $isEditing, recipeManager: self.recipeManager)
                            }
                        })
                            .padding(15)
                            .animation(Animation.easeOut(duration: 0.15))
                    }
                }
                    .navigationBarTitle("\(self.category.name ?? "") Recipes", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading:
                            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: SFSymbols.arrowLeft)
                                    .imageScale(.medium)
                                    .foregroundColor(.black)
                            },
                        trailing:
                            Button(action: { self.isEditing.toggle(); self.modalManager.isRecipeDetailViewShowing = false }) {
                                Text(self.isEditing ? "Done" : "Edit")
                                    .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                                    .foregroundColor(self.isEditing ? .lightRed : .black)
                            }
                    )
            }
            
            if !self.isEditing {
                Button(action: {
                    self.recipeManager.resetRecipeValuesToEmpty()
                    self.recipeManager.isShowingEditRecipe = true
                }) {
                    Image(systemName: SFSymbols.plus)
                        .font(.system(.title))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.075, height: UIScreen.main.bounds.width * 0.075)
                        .padding()
                        .background(Color.mainGreen)
                        .clipShape(Circle())
                }
                    .padding(.bottom, 20)
                    .padding(.trailing, 20)
                    .fullScreenCover(isPresented: self.$recipeManager.isShowingEditRecipe) {
                        AddEditRecipeView(category: self.category, recipeManager: self.recipeManager)
                    }
            }
            
            if modalManager.isRecipeDetailViewShowing {
                CustomModalView(content: RecipeDetailView(recipeManager: self.recipeManager))
                    .animation(Animation.easeInOut(duration: 0.4))
            }
        }
    }
}
