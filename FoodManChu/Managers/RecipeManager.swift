//
//  RecipeManager.swift
//  FoodManChu
//
//  Created by William Yeung on 3/17/21.
//

import SwiftUI

class RecipeManager: ObservableObject {
    @Published var recipe: Recipe?
    @Published var isShowingDeleteRecipeAlert = false
    @Published var isShowingAddRecipe = false
    @Published var isShowingEditRecipe = false
    
    @Published var selectedImage = UIImage(named: "placeholder")!
    @Published var isPhotoLibraryOpen = false
    @Published var isCameraOpen = false
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
            return Text("\(minutes ?? 0.0, specifier: "%.0f")m")
        } else {
            return Text("\(hours ?? 0.0, specifier: "%.0f")h \(minutes ?? 0.0, specifier: "%.0f")m")
        }
    }
    
    var recipeIngredients: [Ingredient] {
        return self.recipe?.ingredients?.allObjects as? [Ingredient] ?? []
    }
    
    var recipeInstructions: [String] {
        return self.recipe?.instructions ?? []
    }
    
    var isRecipeInputValid: Bool {
        return !name.isEmpty && (hours != 0.0 || minutes != 0.0) && !ingredients.isEmpty && !instructions.isEmpty
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
