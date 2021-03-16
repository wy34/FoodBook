//
//  DiscoverMoreView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct DiscoverMoreView: View {
    var recipeRecord: RecipeRecord
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]) var ingredients: FetchedResults<Ingredient>
    
    @State private var saveTapped = false
    @State private var pickerSelection = 0
    var selections = ["Ingredients", "Instructions"]

    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 80)
                    
                    if self.pickerSelection == 0 {
                        ForEach(0..<self.cloudKitManager.ingredients.count, id: \.self) { i in
                            HStack {
                                Text(self.cloudKitManager.ingredients[i].ingredientName)
                                    .font(.custom("Comfortaa-Medium", size: 14, relativeTo: .body))
                                Spacer()
                                Text(self.cloudKitManager.ingredients[i].ingredientAmount)
                                    .font(.custom("Comfortaa-Medium", size: 12, relativeTo: .body))
                            }
                                .padding()
                                .background(Color(#colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1)))
                        }
                            .cornerRadius(10)
                    } else {
                        ForEach(self.cloudKitManager.instructions, id: \.self) { instruction in
                            HStack {
                                Text(instruction)
                                    .padding(.horizontal)
                                Spacer()
                            }
                                .padding(.vertical)
                                .background(Color(#colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1)))
                        }
                            .cornerRadius(10)
                    }
                }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .font(.custom("Comfortaa-Medium", size: 16, relativeTo: .body))
            }
                .navigationBarTitle(recipeRecord.recipeName, displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .imageScale(.medium)
                    },
                    trailing:
                    Button(action: {
                        saveRecipe()
                    }) {
                        Image(systemName: saveTapped ? "checkmark" : "icloud.and.arrow.down")
                            .imageScale(.medium)
                    }
                )
                    .unredacted()

            Picker("", selection: $pickerSelection) {
                ForEach(0..<selections.count, id: \.self) { i in
                    Text(selections[i])
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: UIScreen.main.bounds.width * 0.87)
                .padding(5)
                .background(Color(#colorLiteral(red: 0.8968909383, green: 0.9103438258, blue: 0.9443851113, alpha: 1)))
                .cornerRadius(10)
                .padding(.top)
                .disabled(self.cloudKitManager.ingredients.isEmpty)
        }
            .redacted(reason: self.cloudKitManager.ingredients.isEmpty ? .placeholder : [])
            .onAppear() {
                self.cloudKitManager.fetchIngredientsFor(recipeRecord: self.recipeRecord)
                self.cloudKitManager.fetchInstructionsFor(recipeRecord: self.recipeRecord)
            }
    }
    
    func saveRecipe() {
        let recipe = Recipe(context: moc)
        recipe.recipeName = recipeRecord.recipeName
        recipe.recipeDescription = recipeRecord.recipeDescription
        recipe.recipeThumbnail = recipeRecord.recipeImage.pngData()
        recipe.timeHours = recipeRecord.timeHour
        recipe.timeMinutes = recipeRecord.timeMinute
        recipe.instructions = self.cloudKitManager.instructions
        
        for ingredientRecord in self.cloudKitManager.ingredients {
            if let index = ingredients.firstIndex(where: { $0.name!.lowercased() == ingredientRecord.ingredientName }) {
                ingredients[index].addToRecipe(recipe)
            } else {
                let ingredient = Ingredient(context: moc)
                ingredient.name = ingredientRecord.ingredientName
                ingredient.amount = ingredientRecord.ingredientAmount
                ingredient.addToRecipe(recipe)
                PersistenceController.shared.save()
            }
        }
        
        if let index = categories.firstIndex(where: { $0.name!.lowercased() == recipeRecord.recipeCategory.lowercased() }) {
            recipe.category = self.categories[index]
        } else {
            
        }
        
        PersistenceController.shared.save()
        
        // change checkmark back
        saveTapped = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.saveTapped = false
        }
    }
}
