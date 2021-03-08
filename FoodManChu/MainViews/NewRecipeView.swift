//
//  NewRecipeView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/4/21.
//

import SwiftUI


enum Steps: String {
    case Ingredient
    case Instruction
}

//// MARK: - NewRecipeManager
//class NewRecipeManager: ObservableObject {
//    @Published var selectedImage = UIImage(named: "placeholder")!
//    @Published var isImagePickerOpen = false
//    @Published var name = ""
//    @Published var description = ""
//    @Published var hours = 0.0
//    @Published var minutes = 0.0
//    @Published var ingredients = [Ingredient]()
//    @Published var instructions = [String]()
//}

// MARK: - NewRecipeView
struct NewRecipeView: View {
    var category: Category
//    @StateObject var newRecipeManager = NewRecipeManager()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var recipeManager: RecipeManager
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Details").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        TextField("Name", text: self.$recipeManager.name)
                        ZStack(alignment: .leading) {
                            Text("Description")
                                .foregroundColor(!self.recipeManager.description.isEmpty ? .clear : Color(#colorLiteral(red: 0.7848425508, green: 0.7855817676, blue: 0.7926406264, alpha: 1)))
                            TextEditor(text: self.$recipeManager.description)
                                .padding(.leading, -5)
                        }
                    }
                    
                    Section(header: Text("Thumbnail").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        Button(action: { self.recipeManager.isImagePickerOpen = true }) {
                            Text("Open Image Picker")
                                .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        }

                        Image(uiImage: self.recipeManager.selectedImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                    
                    
                    Section(header: Text("Prep Time").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        HStack {
                            Slider(value: self.$recipeManager.hours, in: 0...23, step: 1)
                            Text("\(self.recipeManager.hours, specifier: "%.0f") h")
                        }

                        HStack {
                            Slider(value: self.$recipeManager.minutes, in: 0...59, step: 1)
                            Text("\(self.recipeManager.minutes, specifier: "%.0f") m")
                        }
                    }
                    
                    Section(header: Text("Other").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        NavigationLink(destination: AddingStepsView(stepsType: .Ingredient)) {
                            Text("Ingredients")
                        }
                        NavigationLink(destination: AddingStepsView(stepsType: .Instruction)) {
                            Text("Instructions")
                        }
                    }

                }
                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                    .navigationBarTitle(Text("New Recipe"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                            }
                    )
                    .sheet(isPresented: self.$recipeManager.isImagePickerOpen) {
                        ImagePicker(selectedImage: self.$recipeManager.selectedImage, isImagePickerOpen: self.$recipeManager.isImagePickerOpen)
                    }
                
                Button(action: {
                    self.createNewRecipe()
                }) {
                     Text("Save")
                        .font(.custom("TypoRoundBoldDemo", size: 24, relativeTo: .body))
                        .foregroundColor(self.recipeManager.name.isEmpty ? Color(.systemGray2) :.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(self.recipeManager.name.isEmpty ? Color.gray : Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .cornerRadius(20)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 10)
                }
                    .padding(.top, 15)
                    .disabled(self.recipeManager.name.isEmpty ? true : false)
            }
        }
        .environmentObject(self.recipeManager)
//            .environmentObject(newRecipeManager)
    }
    
    func createNewRecipe() {
        let recipe = Recipe(context: self.moc)
        recipe.recipeName = self.recipeManager.name
        recipe.recipeDescription = self.recipeManager.description
        recipe.recipeThumbnail = self.recipeManager.selectedImage.pngData()
        recipe.timeHours = self.recipeManager.hours
        recipe.timeMinutes = self.recipeManager.minutes
        recipe.instructions = self.recipeManager.instructions
        self.recipeManager.ingredients.forEach({ $0.addToRecipe(recipe) })
        recipe.category = self.category
        self.persistenceController.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - AddingStepsView
struct AddingStepsView: View {
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var newRecipeManager: NewRecipeManager
    @EnvironmentObject var recipeManager: RecipeManager

    var stepsType: Steps

    @State private var showingPopup = false
    
    var body: some View {
        ZStack {
            Form {
                if self.stepsType == .Ingredient {
                    Button(action: {  }) {
                        Label("Pick From Existing List", systemImage: "book")
                            .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                            .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                    }
                }
                
                Button(action: { self.showingPopup = true }) {
                    Label("Add New \(stepsType.rawValue)", systemImage: "plus")
                        .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                }
                
                if self.stepsType == .Ingredient {
                    ForEach(self.recipeManager.ingredients, id: \.id) { data in
                        HStack {
                            Text(data.name ?? "")
                                .font(.custom("TypoRoundLightDemo", size: 16, relativeTo: .body))
                            Spacer()
                            Text("\(data.amount ?? "")")
                                .font(.custom("TypoRoundLightDemo", size: 12, relativeTo: .body))
                        }
                    }
                        .onDelete(perform: delete(at:))
                } else {
                    ForEach(0..<self.recipeManager.instructions.count, id: \.self) { i in
                        HStack {
                            Text("\(i + 1). " + self.recipeManager.instructions[i])
                                .font(.custom("TypoRoundLightDemo", size: 16, relativeTo: .body))
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
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                )
            
            if self.showingPopup {
                NewStepPopupView(stepsType: stepsType, showingPopup: $showingPopup)
            }
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
    
//    @EnvironmentObject var newRecipeManager: NewRecipeManager
    @EnvironmentObject var recipeManager: RecipeManager

    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var persistenceController: PersistenceController


    
    var body: some View {
        ZStack {
            Color.gray.opacity(0)
            
            VStack {
                Text("New \(stepsType.rawValue)")
                    .padding(.bottom, 5)
                    .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                CustomTextField(text: self.stepsType == .Ingredient ? $ingredientName : $instruction, isFirstResponder: true, placeholder: self.stepsType == .Ingredient ? "Name" : "Instruction")
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .padding(8)
                    .background(Color(#colorLiteral(red: 0.9968960881, green: 0.9921532273, blue: 1, alpha: 1)))
                    .cornerRadius(8)
                    .padding(.bottom, self.stepsType == .Ingredient ? 5 : 8)
                if self.stepsType == .Ingredient {
                    CustomTextField(text: $ingredientAmount, isFirstResponder: false, placeholder: "Amount")
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                        .padding(8)
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
                            .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
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
                            .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
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
            let ingredient = Ingredient(context: self.moc)
            ingredient.name = ingredientName
            ingredient.amount = ingredientAmount
            self.persistenceController.save()
            self.recipeManager.ingredients.append(ingredient)
        } else {
            let instruction = self.instruction
            self.recipeManager.instructions.append(instruction)
        }
        
        self.showingPopup = false
    }
}

// MARK: - IngredientSelectionView
struct IngredientSelectionView: View {
    var body: some View {
        Text("Hello")
    }
}

struct IngredientSelectionView_previews: PreviewProvider {
    static var previews: some View {
        IngredientSelectionView()
    }
}


// MARK: - CustomTextfield
struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var isFirstResponder: Bool = false
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundRegularDemo", size: 16)!)
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        if isFirstResponder && !context.coordinator.hasBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.hasBecomeFirstResponder = true
        }
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        var hasBecomeFirstResponder = false

        init(parent: CustomTextField) {
            self.parent = parent
        }

        // gets called every time we press a key
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

