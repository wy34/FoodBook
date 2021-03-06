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
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews: passed this in as the managedObjectContext
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        for _ in 0..<10 {
            let category = Category(context: controller.container.viewContext)
            category.name = "Vegetarian"
            category.thumbnail = UIImage(named: "food")?.pngData()
        }

        return controller
    }()

    // an initializer to load Core Data, optionally able to use an in-memory store
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
    
    // creating default categories on first time
    func createDefaultCategories() {
        if !UserDefaults.standard.bool(forKey: "oldUser") {
            let names = ["Meat", "Vegan", "Vegetarian", "Paleo", "Keto"]
            let images = [UIImage(named: "meat"), UIImage(named: "vegan"), UIImage(named: "vegetarian"), UIImage(named: "paleo"), UIImage(named: "keto")]
            
            for (index, name) in names.enumerated() {
                let category = Category(context: self.container.viewContext)
                category.name = name
                category.thumbnail = images[index]?.pngData()
                self.save()
            }
            
            UserDefaults.standard.setValue(true, forKey: "oldUser")
        }
    }
    
    // save
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // delete
    func delete(_ object: NSManagedObject) {
        let context = container.viewContext
        context.delete(object)
    }
}

