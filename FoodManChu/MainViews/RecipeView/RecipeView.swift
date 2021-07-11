//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI


struct RecipeView: View {
    // MARK: - Properties
    var category: Category
    @State private var isEditing = false
    @EnvironmentObject var modalManager: ModalManager
    @StateObject var recipeManager = RecipeManager()
    
    // MARK: - Body
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
