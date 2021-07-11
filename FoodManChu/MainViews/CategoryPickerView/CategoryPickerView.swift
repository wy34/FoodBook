//
//  CategoryPickerView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/16/21.
//

import SwiftUI

// MARK: - CategoryPickerView
struct CategoryPickerView: View {
    // MARK: - Properties
    var recipeRecord: RecipeRecord
    let screenSize = UIScreen.main.bounds
    @State private var tappedCategory: Category?
    @State private var tabSelection = 0
    @State private var isPhotoLibraryOpen = false
    @State private var isCameraOpen = false

    @StateObject var categoryManager: CategoryManager = CategoryManager()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]) var ingredients: FetchedResults<Ingredient>

    @State private var height: CGFloat = 0
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $tabSelection) {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            Spacer()
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50, maximum: 100), spacing: 50), count: screenSize.width < 375 ? 2 : 3), alignment: .center, spacing: 15) {
                                Button(action: { withAnimation { self.tabSelection = 1 } }) {
                                    Image(systemName: SFSymbols.plus)
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .frame(width: 75, height: 75)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                ForEach(0..<categories.count) { i in
                                    CircularCategoryView(category: categories[i], tappedCategory: $tappedCategory, categoryManager: self.categoryManager)
                                }
                            }
                            Spacer()
                        }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 25)
                            .padding(.bottom, 75)
                    }
                        .tag(0)
                    
                    AddCategoryForm(categoryManager: categoryManager, isPhotoLibraryOpen: $isPhotoLibraryOpen, isCameraOpen: $isCameraOpen, tabSelection: $tabSelection, tappedCategory: $tappedCategory)
                        .tag(1)
                        .padding(.bottom, self.height)
                }
                    .tabViewStyle(PageTabViewStyle())
                    .onChange(of: tabSelection) { _ in
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                Button(action: { self.saveRecipe() }) {
                    Text("Save")
                        .font(.custom(FBFont.bold, size: 22, relativeTo: .body))
                        .foregroundColor(tappedCategory == nil && categoryManager.categoryName.isEmpty ? Color(.systemGray2) : .white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(tappedCategory == nil && categoryManager.categoryName.isEmpty ? Color.gray : Color.mainGreen)
                        .cornerRadius(15)
                        .padding(.horizontal, 25)
                        .padding(.top, 15)
                        .padding(.bottom, 25)
                        .background(Color.white)
                }
                    .disabled(tappedCategory == nil && categoryManager.categoryName.isEmpty ? true : false)
                    .offset(y: -self.height)
                    .onAppear() {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                            if let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                                withAnimation {
                                    self.height = keyboardFrame.height
                                }
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
                            withAnimation {
                                self.height = 0
                            }
                        }
                    }
            }
                .navigationBarTitle("Pick a category to add to.", displayMode: .inline)
                .edgesIgnoringSafeArea(.bottom)
        }
            .preferredColorScheme(.light)
    }
    
    // MARK: - Helpers
    private func saveRecipe() {
        let recipe = Recipe(context: moc)
        recipe.recipeName = recipeRecord.recipeName
        recipe.recipeDescription = recipeRecord.recipeDescription
        recipe.recipeThumbnail = recipeRecord.recipeImage.pngData()
        recipe.timeHours = recipeRecord.timeHour
        recipe.timeMinutes = recipeRecord.timeMinute
        recipe.instructions = self.cloudKitManager.instructions
        
        for ingredientRecord in self.cloudKitManager.ingredients {
            if let index = ingredients.firstIndex(where: { $0.name!.lowercased() == ingredientRecord.ingredientName.lowercased() }) {
                ingredients[index].amount = ingredientRecord.ingredientAmount
                ingredients[index].addToRecipe(recipe)
            } else {
                let ingredient = Ingredient(context: moc)
                ingredient.name = ingredientRecord.ingredientName
                ingredient.amount = ingredientRecord.ingredientAmount
                ingredient.addToRecipe(recipe)
                PersistenceController.shared.save()
            }
        }
        
        if categoryManager.categoryName != "" {
            if let index = categories.firstIndex(where: { $0.name!.lowercased() == categoryManager.categoryName.lowercased() }) {
                recipe.category = self.categories[index]
            } else {
                let newCategory = Category(context: self.moc)
                newCategory.name = categoryManager.categoryName
                newCategory.thumbnail = categoryManager.categoryImage.pngData()
                recipe.category = newCategory
                PersistenceController.shared.save()
            }
        } else {
            if let index = categories.firstIndex(where: { $0.name!.lowercased() == tappedCategory?.name?.lowercased() }) {
                recipe.category = self.categories[index]
            }
        }
        
        PersistenceController.shared.save()
        presentationMode.wrappedValue.dismiss()
    }
}
