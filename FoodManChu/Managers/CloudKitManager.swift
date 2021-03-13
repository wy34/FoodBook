//
//  CloudKitManager.swift
//  FoodManChu
//
//  Created by William Yeung on 3/12/21.
//

import UIKit
import CloudKit

class CloudKitManager: ObservableObject {
    @Published var successfullySavedRecipe = false
    @Published var successfullySavedIngredients = false
    @Published var successfullySavedInstructions = false
    
    @Published var isLoading = true
    @Published var recipes = [RecipeRecord]()
    @Published var ingredients = [IngredientRecord]()
    @Published var instructions = [String]()
    
    let recipeImageCache = NSCache<CKRecord.ID, NSData>()
    
    
    func createIngredientsRecord(ingredientSet: NSSet?, withRefTo recipeRecord: CKRecord) {
        guard let ingredientsSet = ingredientSet, let ingredientsArray = ingredientsSet.allObjects as? [Ingredient] else { return }
        
        for ingredient in ingredientsArray {
            let ingredientRecord = CKRecord(recordType: "Ingredient")
            let reference = CKRecord.Reference(record: recipeRecord, action: .deleteSelf)
            
            ingredientRecord["parentRecipe"] = reference as CKRecordValue
            
            if let ingredientName = ingredient.name {
                ingredientRecord["ingredientName"] = ingredientName as CKRecordValue
            }
            
            if let ingredientAmount = ingredient.amount {
                ingredientRecord["ingredientAmount"] = ingredientAmount as CKRecordValue
            }
            
            CKContainer.default().publicCloudDatabase.save(ingredientRecord) { [weak self] (record, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.successfullySavedIngredients = false
                        print(error.localizedDescription)
                    }

                    if let _ = record {
                        self?.successfullySavedIngredients = true
                    }
                }
            }
        }
    }
    
    func createInstructionsRecord(instructions: [String], withRefTo recipeRecord: CKRecord) {
        for instruction in instructions {
            let instructionRecord = CKRecord(recordType: "Instruction")
            let reference = CKRecord.Reference(record: recipeRecord, action: .deleteSelf)
            
            instructionRecord["parentRecipe"] = reference as CKRecordValue
            instructionRecord["instruction"] = instruction as CKRecordValue
            
            CKContainer.default().publicCloudDatabase.save(instructionRecord) { [weak self] (record, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.successfullySavedInstructions = false
                        print(error.localizedDescription)
                    }
                    
                    if let _ = record {
                        self?.successfullySavedInstructions = true
                    }
                }
            }
        }
    }
    
    func createRecipeRecord(recipe: Recipe) {
        let recipeRecord = CKRecord(recordType: "Recipe")
        
        if let recipeName = recipe.recipeName {
            recipeRecord["recipeName"] = recipeName as CKRecordValue
        }
        
        if let recipeCategory = recipe.category?.name {
            recipeRecord["recipeCategory"] = recipeCategory as CKRecordValue
        }
        
        if let recipeDescription = recipe.recipeDescription {
            recipeRecord["recipeDescription"] = recipeDescription as CKRecordValue
        }
        
        recipeRecord["timeHour"] = recipe.timeHours as CKRecordValue
        recipeRecord["timeMinute"] = recipe.timeMinutes as CKRecordValue
        
        // for the image
        // scale it down
        let originalImage = UIImage(data: recipe.recipeThumbnail!)!
        let scalingFactor = (originalImage.size.width > 1024) ? (1024 / originalImage.size.width) : 1.0
        let scaledImage = UIImage(data: recipe.recipeThumbnail!, scale: scalingFactor)!
        
        // need url for ckasset - create a temporary one
        let imageFilePath = NSTemporaryDirectory() + recipe.recipeName!
        let imageFileUrl = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.75)?.write(to: imageFileUrl)
        recipeRecord["recipeImage"] = CKAsset(fileURL: imageFileUrl)
        
        // sending to cloud
        CKContainer.default().publicCloudDatabase.save(recipeRecord) { [weak self] (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.successfullySavedRecipe = false
                    print(error.localizedDescription)
                }
                
                if let _ = record {
                    self?.successfullySavedRecipe = true
                }

                try? FileManager.default.removeItem(at: imageFileUrl)
            }
        }
        
        self.createIngredientsRecord(ingredientSet: recipe.ingredients, withRefTo: recipeRecord)
        self.createInstructionsRecord(instructions: recipe.instructions ?? [], withRefTo: recipeRecord)
    }
    
    func fetchRecipeRecords() {
        self.isLoading = true
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Recipe", predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["recipeName", "recipeCategory", "recipeDescription", "timeHour", "timeMinute", "recipeImage"]
        operation.resultsLimit = 50
        
        var loadedRecipes = [RecipeRecord]()
        
        operation.recordFetchedBlock = { record in
            let recipeRecord = RecipeRecord()
            recipeRecord.recipeId = record.recordID
            recipeRecord.recipeName = record["recipeName"] as! String
            recipeRecord.recipeCategory = record["recipeCategory"] as! String
            recipeRecord.recipeDescription = record["recipeDescription"] as! String
            recipeRecord.timeHour = record["timeHour"] as! Double
            recipeRecord.timeMinute = record["timeMinute"] as! Double
            
            if let recipeImage = record["recipeImage"] as? CKAsset {
                if let imageData = try? Data(contentsOf: recipeImage.fileURL!) {
                    recipeRecord.recipeImage = UIImage(data: imageData)!
                }
            }
            
            loadedRecipes.append(recipeRecord)
        }
        
        operation.queryCompletionBlock = { [weak self] (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.recipes = []
                    print(error.localizedDescription)
                }
                
                self?.isLoading = false
                self?.recipes = loadedRecipes
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func fetchIngredientsFor(recipeRecord: RecipeRecord) {
        let reference = CKRecord.Reference(recordID: recipeRecord.recipeId, action: .deleteSelf)
        let predicate = NSPredicate(format: "parentRecipe == %@", reference)
        let sort = NSSortDescriptor(key: "ingredientName", ascending: true)
        let query = CKQuery(recordType: "Ingredient", predicate: predicate)
        query.sortDescriptors = [sort]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.ingredients = []
                    print(error.localizedDescription)
                }
                
                if let records = records {
                    var newIngredients = [IngredientRecord]()
                    
                    for record in records {
                        let ingredientRecord = IngredientRecord()
                        ingredientRecord.ingredientName = record["ingredientName"] as! String
                        ingredientRecord.ingredientAmount = record["ingredientAmount"] as! String
                        newIngredients.append(ingredientRecord)
                    }
                    
                    self?.ingredients = newIngredients
                }
            }
        }
    }
    
    func fetchInstructionsFor(recipeRecord: RecipeRecord) {
        let reference = CKRecord.Reference(recordID: recipeRecord.recipeId, action: .deleteSelf)
        let predicate = NSPredicate(format: "parentRecipe == %@", reference)
        let query = CKQuery(recordType: "Instruction", predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.instructions = []
                    print(error.localizedDescription)
                }
                
                if let records = records {
                    var newInstructions = [String]()
                    
                    for record in records {
                        newInstructions.append(record["instruction"] as! String)
                    }
                    
                    self?.instructions = newInstructions
                }
            }
        }
    }
}

class RecipeRecord: NSObject, Identifiable {
    var id = UUID().uuidString
    var recipeId: CKRecord.ID!
    var recipeName: String = ""
    var recipeCategory: String = ""
    var recipeDescription: String = ""
    var recipeImage: UIImage = UIImage()
    var timeHour: Double = 0.0
    var timeMinute: Double = 0.0
}

class IngredientRecord: NSObject, Identifiable {
    var id = UUID().uuidString
    var ingredientName: String = ""
    var ingredientAmount: String = ""
}
