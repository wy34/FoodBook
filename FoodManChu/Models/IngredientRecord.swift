//
//  IngredientRecord.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import Foundation

class IngredientRecord: NSObject, Identifiable {
    var id = UUID().uuidString
    var ingredientName: String = ""
    var ingredientAmount: String = ""
}
