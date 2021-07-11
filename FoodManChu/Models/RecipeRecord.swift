//
//  RecipeRecord.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import UIKit
import CloudKit

class RecipeRecord: NSObject, Identifiable {
    var id = UUID().uuidString
    var recipeId: CKRecord.ID!
    var recipeName: String = ""
    var recipeCategory: String = ""
    var recipeDescription: String = ""
    var recipeImage: UIImage = UIImage()
    var timeHour: Double = 0.0
    var timeMinute: Double = 0.0
    var creationDate: Date?
}
