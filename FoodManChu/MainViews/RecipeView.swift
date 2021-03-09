//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI


class RecipeManager: ObservableObject {
    @Published var recipe: Recipe?
    @Published var isShowingDeleteRecipeAlert = false
    @Published var isShowingAddRecipe = false
    @Published var isShowingEditRecipe = false
    
    @Published var selectedImage = UIImage(named: "placeholder")!
    @Published var isImagePickerOpen = false
    @Published var name = ""
    @Published var description = ""
    @Published var hours = 0.0
    @Published var minutes = 0.0
    @Published var ingredients = [Ingredient]()
    @Published var instructions = [String]()
    
    var recipeName: String {
        return self.recipe?.recipeName ?? ""
    }
    
    var recipeImage: UIImage {
        return UIImage(data: self.recipe?.recipeThumbnail ?? Data())!
    }
    
    var recipeDescription: String {
        return self.recipe?.recipeDescription ?? ""
    }
    
    var formattedPrepTimeText: Text {
        let hours = self.recipe?.timeHours
        let minutes = self.recipe?.timeMinutes
        
        if hours == 0.0 {
            return Text("\(minutes ?? 0.0, specifier: "%.0f") m")
        } else {
            return Text("\(hours ?? 0.0, specifier: "%.0f") h \(minutes ?? 0.0, specifier: "%.0f") m")
        }
    }
    
    var recipeIngredients: [Ingredient] {
        return self.recipe?.ingredients?.allObjects as? [Ingredient] ?? []
    }
    
    var recipeInstructions: [String] {
        return self.recipe?.instructions ?? []
    }
    
    func resetRecipeValuesToEmpty() {
        self.name = ""
        self.description = ""
        self.selectedImage = UIImage(named: "placeholder")!
        self.hours = 0.0
        self.minutes = 0.0
        self.ingredients = [Ingredient]()
        self.instructions = [String]()
    }
}

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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modalManager: ModalManager
    @Binding var isEditing: Bool
    let recipes: FetchRequest<Recipe>
    
    init(category: Category, isEditing: Binding<Bool>, recipeManager: RecipeManager) {
        self.category = category
        _isEditing = isEditing
        self.recipes = FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipeName, ascending: true)], predicate: NSPredicate(format: "category.name MATCHES %@",  category.name ?? ""))
        self.recipeManager = recipeManager
    }
    
    @ObservedObject var recipeManager: RecipeManager
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                ScrollView(showsIndicators: false) {
                    SearchBar(placeholder: "Search Recipes")
                        .padding(.top, 15)
                        .padding(.horizontal, 5)
                    
                    // this spacing is between rows
                    LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                        ForEach(recipes.wrappedValue, id: \.self) { recipe in
                            RecipeCell(recipe: recipe, category: self.category, isEditing: $isEditing, recipeManager: self.recipeManager)
                        }
                    })
                        .padding(15)
                        .animation(Animation.easeOut(duration: 0.15))
                }
                    .navigationBarTitle("\(self.category.name ?? "") Recipes", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(
                        leading:
                            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "arrow.left")
                                    .imageScale(.large)
                                    .foregroundColor(.black)
                            },
                        trailing:
                            Button(action: { self.isEditing.toggle(); self.modalManager.isRecipeDetailViewShowing = false }) {
                                Text(self.isEditing ? "Done" : "Edit")
                                    .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                                    .foregroundColor(self.isEditing ? .red : .black)
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
    @EnvironmentObject var modalManager: ModalManager
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var persistenceController: PersistenceController

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
                        .cornerRadius(30)
                }
                
                if self.isEditing {
                    RoundedRectangle(cornerRadius: 30)
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
                            Button(action: {
                                self.recipeManager.isShowingDeleteRecipeAlert = true
                                self.recipeManager.recipe = self.recipe
                            }) {
                                Image(systemName: "trash")
                                    .imageScale(.medium)
                                    .foregroundColor(.white)
                                    .padding(12)
                            }
                                .background(RoundedButtonView(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], bgColor: #colorLiteral(red: 0.997196734, green: 0.2449620962, blue: 0.2093260586, alpha: 0.7458057316), cornerRadius: 30))
                            , alignment: .topLeading
                        )
                } 
            }
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                .animation(.easeInOut)
                
            Text(recipe.recipeName ?? "")
                .multilineTextAlignment(.center)
                .font(.custom("TypoRoundRegularDemo", size: 18, relativeTo: .body))
                .frame(width: screenSize.width / 2 - 35)
                .lineLimit(nil)
                .padding(.top, 3)
        }
            .fullScreenCover(isPresented: self.$recipeManager.isShowingAddRecipe, content: {
                AddEditRecipeView(recipeManager: self.recipeManager)
            })
            .alert(isPresented: $recipeManager.isShowingDeleteRecipeAlert) {
                Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this recipe?"), primaryButton: .cancel(), secondaryButton: .default(Text("Yes")) {
                        if let recipe = self.recipeManager.recipe {
                            self.persistenceController.delete(recipe)
                            self.persistenceController.save()
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
