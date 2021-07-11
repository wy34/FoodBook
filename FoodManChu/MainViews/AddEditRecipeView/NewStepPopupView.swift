//
//  PopupView.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct NewStepPopupView: View {
    // MARK: - Properties
    var stepsType: Steps
    @Binding var showingPopup: Bool
    
    @State private var ingredientName = ""
    @State private var ingredientAmount = ""
    @State private var instruction = ""
    @State private var scales = false
    
    @ObservedObject var recipeManager: RecipeManager

    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]) var ingredients: FetchedResults<Ingredient>

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.gray.opacity(0)
            
            VStack {
                Text("New \(stepsType.rawValue)")
                    .padding(.bottom, 5)
                    .font(.custom(FBFont.bold, size: 16, relativeTo: .body))
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
                            .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
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
                            .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.mainGreen)
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
    
    // MARK: - Helpers
    private func createNewStep() {
        guard ingredientName != "" || instruction != "" else { return }
       
        if self.stepsType == .Ingredient {
            let matchingIngredientFromCoreData = self.ingredients.filter({ $0.name?.lowercased() == ingredientName.lowercased() })
            let matchingIngredientFromRecipeManager = self.recipeManager.ingredients.filter({ $0.name?.lowercased() == ingredientName.lowercased() })

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
