//
//  NewRecipeView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/4/21.
//

import SwiftUI


// MARK: - AddEditRecipeView
struct AddEditRecipeView: View {
    var category: Category?
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var recipeManager: RecipeManager
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Details").font(.custom("Comfortaa-Medium", size: 10, relativeTo: .body))) {
                        TextField("Name", text: self.$recipeManager.name)

                        ZStack(alignment: .leading) {
                            Text("Description (Optional)")
                                .foregroundColor(!self.recipeManager.description.isEmpty ? .clear : Color(#colorLiteral(red: 0.7848425508, green: 0.7855817676, blue: 0.7926406264, alpha: 1)))
                            TextEditor(text: self.$recipeManager.description)
                                .padding(.leading, -5)
                        }
                    }
                    
                    Section(header: Text("Thumbnail (Optional)").font(.custom("Comfortaa-Medium", size: 10, relativeTo: .body))) {
                        Button(action: { self.recipeManager.isPhotoLibraryOpen = true }) {
                            Text("Photo Library")
                                .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        }
                        
                        Button(action: { self.recipeManager.isCameraOpen = true }) {
                            Text("Camera")
                                .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        }

                        Image(uiImage: self.recipeManager.selectedImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                    
                    
                    Section(header: Text("Prep Time").font(.custom("Comfortaa-Medium", size: 10, relativeTo: .body))) {
                        HStack {
                            Slider(value: self.$recipeManager.hours, in: 0...23, step: 1)
                            Text("\(self.recipeManager.hours, specifier: "%.0f") h")
                        }

                        HStack {
                            Slider(value: self.$recipeManager.minutes, in: 0...59, step: 1)
                            Text("\(self.recipeManager.minutes, specifier: "%.0f") m")
                        }
                    }
                    
                    Section(header: Text("Other").font(.custom("Comfortaa-Medium", size: 10, relativeTo: .body))) {
                        NavigationLink(destination: AddingStepsView(stepsType: .Ingredient, recipeManager: self.recipeManager)) {
                            Text("Ingredients")
                        }
                        NavigationLink(destination: AddingStepsView(stepsType: .Instruction, recipeManager: self.recipeManager)) {
                            Text("Instructions")
                        }
                    }

                }
                    .font(.custom("Comfortaa-Medium", size: 14, relativeTo: .body))
                    .navigationBarTitle(Text(self.category == nil ? "Edit \(self.recipeManager.recipeName)" : "New Recipe"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
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
                        .font(.custom("Comfortaa-Bold", size: 22, relativeTo: .body))
                        .foregroundColor(!self.recipeManager.isRecipeInputValid ? Color(.systemGray2) : .white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(!self.recipeManager.isRecipeInputValid ? Color.gray : Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
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
    
    func createRecipe() {
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
    
    func editRecipe() {
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

// MARK: - AddingStepsView
struct AddingStepsView: View {
    var stepsType: Steps
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeManager: RecipeManager
    @State private var isShowingExistingList = false
    @State private var showingPopup = false


    var body: some View {
        ZStack {
            Form {
                if self.stepsType == .Ingredient {
                    Button(action: { self.isShowingExistingList = true }) {
                        Label("Pick From Existing List", systemImage: "book")
                            .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                            .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                    }
                }
                
                Button(action: { self.showingPopup = true }) {
                    Label("Add New \(stepsType.rawValue)", systemImage: "plus")
                        .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                }
                
                if self.stepsType == .Ingredient {
                    ForEach(self.recipeManager.ingredients, id: \.id) { data in
                        HStack {
                            Text(data.name ?? "")
                                .font(.custom("comfortaa-light", size: 14, relativeTo: .body))
                            Spacer()
                            Text("\(data.amount ?? "")")
                                .font(.custom("comfortaa-light", size: 12, relativeTo: .body))
                        }
                    }
                        .onDelete(perform: delete(at:))
                } else {
                    ForEach(0..<self.recipeManager.instructions.count, id: \.self) { i in
                        HStack {
                            Text(self.recipeManager.instructions[i])
                                .font(.custom("comfortaa-light", size: 14, relativeTo: .body))
                            Spacer()
                        }
                    }
                        .onDelete(perform: delete(at:))
                }
            }
                .navigationBarTitle(self.stepsType.rawValue + "s")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .imageScale(.medium)
                            .foregroundColor(.black)
                    }
                )
            
            if self.showingPopup {
                NewStepPopupView(stepsType: stepsType, showingPopup: $showingPopup, recipeManager: self.recipeManager)
            }
        }
            .preferredColorScheme(.light)   
            .sheet(isPresented: $isShowingExistingList) {
                ExistingIngredientView(recipeManager: self.recipeManager)
                    
            }
    }
    
    func delete(at offsets: IndexSet) {
        if self.stepsType == .Ingredient {
            offsets.forEach { self.recipeManager.ingredients.remove(at: $0) }
        } else {
            offsets.forEach { self.recipeManager.instructions.remove(at: $0) }
        }
    }
}

// MARK: - PopupView
struct NewStepPopupView: View {
    var stepsType: Steps
    @Binding var showingPopup: Bool
    
    @State private var ingredientName = ""
    @State private var ingredientAmount = ""
    @State private var instruction = ""
    @State private var scales = false
    
    @ObservedObject var recipeManager: RecipeManager

    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]) var ingredients: FetchedResults<Ingredient>

    var body: some View {
        ZStack {
            Color.gray.opacity(0)
            
            VStack {
                Text("New \(stepsType.rawValue)")
                    .padding(.bottom, 5)
                    .font(.custom("Comfortaa-Bold", size: 16, relativeTo: .body))
                ActiveTextField(text: self.stepsType == .Ingredient ? $ingredientName : $instruction, isFirstResponder: true, placeholder: self.stepsType == .Ingredient ? "Name" : "Instruction")
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .padding(.horizontal, 10)
                    .padding(.vertical, -2)
                    .background(Color(#colorLiteral(red: 0.9968960881, green: 0.9921532273, blue: 1, alpha: 1)))
                    .cornerRadius(8)
                    .padding(.bottom, self.stepsType == .Ingredient ? 5 : 8)
                if self.stepsType == .Ingredient {
                    ActiveTextField(text: $ingredientAmount, isFirstResponder: false, placeholder: "Amount")
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                        .padding(.horizontal, 10)
                        .padding(.vertical, -2)
                        .background(Color(#colorLiteral(red: 0.9968960881, green: 0.9921532273, blue: 1, alpha: 1)))
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                }
                HStack(spacing: 10) {
                    Button(action: {
                        self.scales = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.showingPopup = false
                        }
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        withAnimation {
                            self.createNewStep()
                        }
                    }) {
                        Text("OK")
                            .foregroundColor(.white)
                            .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                            .cornerRadius(10)
                    }
                }
            }
                .frame(width: UIScreen.main.bounds.width * 0.65, height: self.stepsType == .Ingredient ? 175 : 125)
                .padding(20)
                .background(Color(#colorLiteral(red: 0.9185401797, green: 0.9303612113, blue: 0.9379972816, alpha: 1)))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )
                .scaleEffect(self.scales ? 1 : 0)
                .animation(.easeIn)
        }
            .onAppear() {
                withAnimation(.easeIn) {
                    self.scales = true
                }
            }
    }
    
    
    func createNewStep() {
        guard ingredientName != "" || instruction != "" else { return }
       
        if self.stepsType == .Ingredient {
            // only add to offical core data list if not already existing based on spelling of name only
            let matchingIngredientFromCoreData = self.ingredients.filter({ $0.name?.lowercased() == ingredientName.lowercased() })
            let matchingIngredientFromRecipeManager = self.recipeManager.ingredients.filter({ $0.name?.lowercased() == ingredientName.lowercased() })

            // if adding a brand new ingredient
            if matchingIngredientFromCoreData.count == 0 {
                let ingredient = Ingredient(context: self.moc)
                ingredient.name = ingredientName
                ingredient.amount = ingredientAmount
                PersistenceController.shared.save()
                self.recipeManager.ingredients.append(ingredient)
            } else if matchingIngredientFromRecipeManager.count != 0 {
                if let first = matchingIngredientFromRecipeManager.first {
                    first.amount = self.ingredientAmount
                }
            } else {
                // this way allows a same ingredient to not be added to list again but still show up in list
                // adding an ingredient to that recipe list, but already exists inside of the ingredients database
                if let first = matchingIngredientFromCoreData.first {
                    first.amount = self.ingredientAmount
                    self.recipeManager.ingredients.append(first)
                }
            }
        } else {
            let instruction = self.instruction
            self.recipeManager.instructions.append("\(self.recipeManager.instructions.count + 1).  \(instruction)")
        }
        
        self.showingPopup = false
    }
}

// MARK: - ActiveTextField
struct ActiveTextField: UIViewRepresentable {
    @Binding var text: String
    var isFirstResponder: Bool = false
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<ActiveTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "Comfortaa-Medium", size: 14)!)
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<ActiveTextField>) {
        if isFirstResponder && !context.coordinator.hasBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.hasBecomeFirstResponder = true
        }
    }
    
    func makeCoordinator() -> ActiveTextField.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: ActiveTextField
        var hasBecomeFirstResponder = false

        init(parent: ActiveTextField) {
            self.parent = parent
        }

        // gets called every time we press a key
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

