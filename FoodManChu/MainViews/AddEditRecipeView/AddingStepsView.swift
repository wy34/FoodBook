//
//  AddingStepsView.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI


struct AddingStepsView: View {
    // MARK: - Properties
    var stepsType: Steps
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeManager: RecipeManager
    @State private var isShowingExistingList = false
    @State private var showingPopup = false

    // MARK: - Body
    var body: some View {
        ZStack {
            Form {
                if self.stepsType == .Ingredient {
                    Button(action: { self.isShowingExistingList = true }) {
                        Label("Pick From Existing List", systemImage: "book")
                            .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                            .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                    }
                }
                
                Button(action: { self.showingPopup = true }) {
                    Label("Add New \(stepsType.rawValue)", systemImage: "plus")
                        .foregroundColor(.mainGreen)
                        .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                }
                
                if self.stepsType == .Ingredient {
                    ForEach(self.recipeManager.ingredients, id: \.id) { data in
                        HStack {
                            Text(data.name ?? "")
                                .font(.custom(FBFont.light, size: 14, relativeTo: .body))
                            Spacer()
                            Text("\(data.amount ?? "")")
                                .font(.custom(FBFont.light, size: 12, relativeTo: .body))
                        }
                    }
                        .onDelete(perform: delete(at:))
                } else {
                    ForEach(0..<self.recipeManager.instructions.count, id: \.self) { i in
                        HStack {
                            Text(self.recipeManager.instructions[i])
                                .font(.custom(FBFont.light, size: 14, relativeTo: .body))
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
                        Image(systemName: SFSymbols.arrowLeft)
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
    
    // MARK: - Helpers
    private func delete(at offsets: IndexSet) {
        if self.stepsType == .Ingredient {
            offsets.forEach { self.recipeManager.ingredients.remove(at: $0) }
        } else {
            offsets.forEach { self.recipeManager.instructions.remove(at: $0) }
        }
    }
}
