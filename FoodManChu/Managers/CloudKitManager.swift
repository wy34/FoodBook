//
//  CloudKitManager.swift
//  FoodManChu
//
//  Created by William Yeung on 3/12/21.
//

import UIKit
import CloudKit
import Network

class CloudKitManager: ObservableObject {
    // MARK: - Properties
    @Published var finishedTask = false
    
    @Published var isLoading = true
    @Published var recipes = [RecipeRecord]()
    @Published var ingredients = [IngredientRecord]()
    @Published var instructions = [String]()
    
    @Published var isConnectedToInternet = false
    
    var successfullySavedRecipe = false
    var successfullySavedIngredients = false
    var successfullySavedInstructions = false
    
    let recipeImageCache = NSCache<CKRecord.ID, UIImage>()
    
    let monitor = NWPathMonitor()
    var wasPreviouslyConnected = false
    
    // MARK: - Helpers
    func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [unowned self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.isConnectedToInternet = true
                } else {
                    self.isConnectedToInternet = false
                }
                
                if !wasPreviouslyConnected && isConnectedToInternet {
                    self.fetchRecipeRecords()
                    self.wasPreviouslyConnected = true
                } else if !isConnectedToInternet {
                    self.wasPreviouslyConnected = false
                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
        
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
            
            CKContainer.default().publicCloudDatabase.save(ingredientRecord) { (record, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }

                    if let _ = record {
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
            
            CKContainer.default().publicCloudDatabase.save(instructionRecord) { (record, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                    
                    if let _ = record {
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
                
        let originalImage = UIImage(data: recipe.recipeThumbnail!)!
        let scalingFactor = (originalImage.size.width > 1024) ? (1024 / originalImage.size.width) : 1.0
        let scaledImage = UIImage(data: recipe.recipeThumbnail!, scale: scalingFactor)!
        
        let imageFilePath = NSTemporaryDirectory() + recipe.recipeName!
        let imageFileUrl = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.75)?.write(to: imageFileUrl)
        recipeRecord["recipeImage"] = CKAsset(fileURL: imageFileUrl)
        
        CKContainer.default().publicCloudDatabase.save(recipeRecord) { [weak self] (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.successfullySavedRecipe = false
                    self?.finishedTask = true
                    debugPrint(error.localizedDescription)
                }
                
                if let _ = record {
                    self?.successfullySavedRecipe = true
                    self?.finishedTask = true
                }

                try? FileManager.default.removeItem(at: imageFileUrl)
            }
        }
        
        self.createIngredientsRecord(ingredientSet: recipe.ingredients, withRefTo: recipeRecord)
        self.createInstructionsRecord(instructions: recipe.instructions ?? [], withRefTo: recipeRecord)
    }
    
    func fetchRecipeRecords() {
        self.recipes.removeAll()
        self.isLoading = true
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Recipe", predicate: predicate)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["recipeName", "recipeCategory", "recipeDescription", "timeHour", "timeMinute"]
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
            recipeRecord.creationDate = record.creationDate
            loadedRecipes.append(recipeRecord)
        }

        operation.queryCompletionBlock = { [weak self] (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    debugPrint(error.localizedDescription)
                }

                if !loadedRecipes.isEmpty {
                    self?.fetchRecipeImages(recipeRecords: loadedRecipes)
                } else {
                    self?.isLoading = false
                    self?.recipes = []
                }
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func fetchRecipeImages(recipeRecords: [RecipeRecord]) {
        var recipeRecordsWithImage = [RecipeRecord]()
        
        for recipeRecord in recipeRecords {
            if let recipeImage = recipeImageCache.object(forKey: recipeRecord.recipeId) {
                recipeRecord.recipeImage = recipeImage
                recipeRecordsWithImage.append(recipeRecord)
                self.isLoading = false
                self.recipes = recipeRecordsWithImage
            } else {
                let perRecordFetchOperation = CKFetchRecordsOperation(recordIDs: [recipeRecord.recipeId])
                perRecordFetchOperation.desiredKeys = ["recipeImage"]
                perRecordFetchOperation.queuePriority = .veryHigh

                perRecordFetchOperation.perRecordCompletionBlock = { [weak self] (record, recordID, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self?.recipes = []
                            debugPrint(error.localizedDescription)
                        }

                        if let record = record {
                            if let asset = record["recipeImage"] as? CKAsset {
                                if let data = try? Data(contentsOf: asset.fileURL!) {
                                    recipeRecord.recipeImage = UIImage(data: data)!
                                    self?.recipeImageCache.setObject(UIImage(data: data)!, forKey: recipeRecord.recipeId)
                                    recipeRecordsWithImage.append(recipeRecord)
                                    self?.isLoading = false
                                    self?.recipes = recipeRecordsWithImage
                                }
                            }
                        }
                    }
                }

                CKContainer.default().publicCloudDatabase.add(perRecordFetchOperation)
            }
        }
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
                    debugPrint(error.localizedDescription)
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
        let sort = NSSortDescriptor(key: "instruction", ascending: true)
        query.sortDescriptors = [sort]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.instructions = []
                    debugPrint(error.localizedDescription)
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
