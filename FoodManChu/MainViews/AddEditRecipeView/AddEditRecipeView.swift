//
//  NewRecipeView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/4/21.
//

import SwiftUI


struct AddEditRecipeView: View {
    // MARK: - Properties
    var category: Category?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var recipeManager: RecipeManager
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Details").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                        TextField("Name", text: self.$recipeManager.name)

                        ZStack(alignment: .leading) {
                            Text("Description (Optional)")
                                .foregroundColor(!self.recipeManager.description.isEmpty ? .clear : Color(#colorLiteral(red: 0.7848425508, green: 0.7855817676, blue: 0.7926406264, alpha: 1)))
                            TextEditor(text: self.$recipeManager.description)
                                .padding(.leading, -5)
                        }
                    }
                    
                    Section(header: Text("Thumbnail (Optional)").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                        Button(action: { self.recipeManager.isPhotoLibraryOpen = true }) {
                            Text("Photo Library")
                                .foregroundColor(.mainGreen)
                        }
                        
                        Button(action: { self.recipeManager.isCameraOpen = true }) {
                            Text("Camera")
                                .foregroundColor(.mainGreen)
                        }

                        Image(uiImage: self.recipeManager.selectedImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                    
                    
                    Section(header: Text("Time").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                        HStack {
                            Slider(value: self.$recipeManager.hours, in: 0...23, step: 1)
                            Text("\(self.recipeManager.hours, specifier: "%.0f") h")
                        }

                        HStack {
                            Slider(value: self.$recipeManager.minutes, in: 0...59, step: 1)
                            Text("\(self.recipeManager.minutes, specifier: "%.0f") m")
                        }
                    }
                    
                    Section(header: Text("Other").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                        NavigationLink(destination: AddingStepsView(stepsType: .Ingredient, recipeManager: self.recipeManager)) {
                            Text("Ingredients")
                        }
                        NavigationLink(destination: AddingStepsView(stepsType: .Instruction, recipeManager: self.recipeManager)) {
                            Text("Instructions")
                        }
                    }

                }
                    .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
                    .navigationBarTitle(Text(self.category == nil ? "Edit \(self.recipeManager.recipeName)" : "New Recipe"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: SFSymbols.xmark)
                                .imageScale(.medium)
                                .foregroundColor(.primary)
                            }
                    )
                    .sheet(isPresented: self.recipeManager.isPhotoLibraryOpen ? self.$recipeManager.isPhotoLibraryOpen : self.$recipeManager.isCameraOpen) {
                        ImagePicker(sourceType: self.recipeManager.isPhotoLibraryOpen ? .photoLibrary : .camera, selectedImage: self.$recipeManager.selectedImage, isImagePickerOpen: self.recipeManager.isPhotoLibraryOpen ? self.$recipeManager.isPhotoLibraryOpen : self.$recipeManager.isCameraOpen)
                    }
                
                Button(action: {
                    if let _ = self.category {
                        self.createRecipe()
                    } else {
                        self.editRecipe()
                    }
                    
                    PersistenceController.shared.save()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                     Text("Save")
                        .font(.custom(FBFont.bold, size: 22, relativeTo: .body))
                        .foregroundColor(!self.recipeManager.isRecipeInputValid ? Color(.systemGray2) : .white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(!self.recipeManager.isRecipeInputValid ? Color.gray : Color.mainGreen)
                        .cornerRadius(20)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 10)
                }
                    .padding(.top, 15)
                    .disabled(!self.recipeManager.isRecipeInputValid ? true : false)
            }
        }
            .preferredColorScheme(.light)
    }
    
    // MARK: - Helpers
    private func createRecipe() {
        let recipe = Recipe(context: self.moc)
        recipe.recipeName = self.recipeManager.name
        recipe.recipeDescription = self.recipeManager.description
        recipe.recipeThumbnail = self.recipeManager.selectedImage.pngData()
        recipe.timeHours = self.recipeManager.hours
        recipe.timeMinutes = self.recipeManager.minutes
        recipe.instructions = self.recipeManager.instructions
        self.recipeManager.ingredients.forEach({ $0.addToRecipe(recipe) })
        recipe.category = category
        self.recipeManager.isShowingAddRecipe = false
    }
    
    private func editRecipe() {
        self.recipeManager.recipe?.recipeName = self.recipeManager.name
        self.recipeManager.recipe?.recipeDescription = self.recipeManager.description
        self.recipeManager.recipe?.recipeThumbnail = self.recipeManager.selectedImage.pngData()
        self.recipeManager.recipe?.timeHours = self.recipeManager.hours
        self.recipeManager.recipe?.timeMinutes = self.recipeManager.minutes
        self.recipeManager.recipe?.ingredients = NSSet(array: self.recipeManager.ingredients)
        self.recipeManager.recipe?.instructions = self.recipeManager.instructions
        self.recipeManager.isShowingEditRecipe = false
    }
}

