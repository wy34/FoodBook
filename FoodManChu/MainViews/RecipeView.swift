//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI


// MARK: - RecipeView
struct RecipeView: View {
    var category: Category
    @State private var isEditing = false
    @EnvironmentObject var modalManager: ModalManager
    @StateObject var recipeManager = RecipeManager()
    
    var body: some View {
        ZStack {
            RecipeGrid(category: category, isEditing: $isEditing, recipeManager: self.recipeManager)
                .onDisappear() {
                    self.modalManager.isRecipeDetailViewShowing = false
                    self.isEditing = false
                }
        }
    }
}

// MARK: - RecipeGrid
struct RecipeGrid: View {
    var category: Category
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200), spacing: 15), count: 2)
    let screenSize = UIScreen.main.bounds
    let recipes: FetchRequest<Recipe>

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modalManager: ModalManager
    @Binding var isEditing: Bool
    @State private var searchText = ""
    @ObservedObject var recipeManager: RecipeManager

    init(category: Category, isEditing: Binding<Bool>, recipeManager: RecipeManager) {
        self.category = category
        _isEditing = isEditing
        self.recipeManager = recipeManager
        self.recipes = FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipeName, ascending: true)], predicate: NSPredicate(format: "category.name MATCHES %@",  category.name ?? ""))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                ScrollView(showsIndicators: false) {
                    SearchBar(placeholder: "Search Recipes", searchText: $searchText)
                        .padding(.top, 15)
                        .padding(.horizontal, 5)
                    
                    if self.recipes.wrappedValue.isEmpty {
                        Text("No \(category.name ?? "") recipes. Press the green plus button to start adding one.")
                            .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .padding(.top, 75)
                    } else {
                        // this spacing is between rows
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
                                Image(systemName: "arrow.left")
                                    .imageScale(.medium)
                                    .foregroundColor(.black)
                            },
                        trailing:
                            Button(action: { self.isEditing.toggle(); self.modalManager.isRecipeDetailViewShowing = false }) {
                                Text(self.isEditing ? "Done" : "Edit")
                                    .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                                    .foregroundColor(self.isEditing ? Color(#colorLiteral(red: 1, green: 0.4903432131, blue: 0.4654182792, alpha: 0.7518001152)) : .black)
                            }
                    )
            }
            
            if !self.isEditing {
                Button(action: {
                    self.recipeManager.resetRecipeValuesToEmpty()
                    self.recipeManager.isShowingEditRecipe = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(.title))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.075, height: UIScreen.main.bounds.width * 0.075)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
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

// MARK: - RecipeCell
struct RecipeCell: View {
    let screenSize = UIScreen.main.bounds
    var recipe: Recipe
    var category: Category
    
    @Binding var isEditing: Bool
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var modalManager: ModalManager
    @Environment(\.managedObjectContext) var moc

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
                                Image(systemName: "pencil.circle")
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
                                    Image(systemName: "trash")
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
                                Image(systemName: "plus.rectangle.on.rectangle")
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
                .font(.custom("Comfortaa-Medium", size: 16, relativeTo: .body))
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
    
    func setRecipeValuesToPublished() {
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
