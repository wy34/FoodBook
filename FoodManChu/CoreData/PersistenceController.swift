//
//  PersistenceController.swift
//  FoodManChu
//
//  Created by William Yeung on 3/5/21.
//

import UIKit
import SwiftUI
import CoreData

class PersistenceController: ObservableObject {
    // MARK: - Properties
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        for _ in 0..<10 {
            let category = Category(context: controller.container.viewContext)
            category.name = "Vegetarian"
            category.thumbnail = UIImage(named: "food")?.pngData()
        }

        return controller
    }()

    // MARK: - Init
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Helpers
    func createDefaultCategories() {
        if !UserDefaults.standard.bool(forKey: "hasDefaultCategories") {
            let names = ["Meat", "Vegan", "Vegetarian", "Paleo", "Keto"]
            let images = [UIImage(named: "meat"), UIImage(named: "vegan"), UIImage(named: "vegetarian"), UIImage(named: "paleo"), UIImage(named: "keto")]
            
            for (index, name) in names.enumerated() {
                let category = Category(context: self.container.viewContext)
                category.name = name
                category.thumbnail = images[index]?.pngData()
                self.save()
            }
            
            UserDefaults.standard.setValue(true, forKey: "hasDefaultCategories")
        }
    }
    
    func createDefaultIngredients() {
        if !UserDefaults.standard.bool(forKey: "hasDefaultIngredients") {
            let defaultIngredients = [
                "Chicken", "Beef", "Pork", "Broccoli", "Apple", "Orange", "Onion", "Pepper", "Salt", "Water", "Sugar", "Vinegar", "Milk", "Flour", "Cheese", "Eggs", "Tomato", "Potato", "Butter", "Chocolate", "Ketchup", "Olive Oil", "Rice", "Garlic", "Bread", "Carrot", "Celery", "Cinnamin", "Vanilla", "Corn", "Shrimp", "Fish", "Spinich", "Pasta", "Lemon", "Honey", "Beef Broth", "Rosemary", "Green Beans", "Lettuce", "Cabbage", "Bacon", "Mushroom", "Soy Sauce", "Banana", "Oats", "Yogurt", "Whip Cream", "Baking Soda", "Hot Dog"
            ]
            
            for ingredientName in defaultIngredients {
                let ingredientObj = Ingredient(context: self.container.viewContext)
                ingredientObj.name = ingredientName
                ingredientObj.amount = ""
                self.save()
            }
            
            UserDefaults.standard.setValue(true, forKey: "hasDefaultIngredients")
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        let context = container.viewContext
        context.delete(object)
    }
    
    func deleteAllIngredients() {
        let request = NSBatchDeleteRequest(fetchRequest: Ingredient.fetchRequest())
        
        do {
            try container.viewContext.execute(request)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}


