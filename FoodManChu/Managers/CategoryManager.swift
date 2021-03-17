//
//  CategoryManager.swift
//  FoodManChu
//
//  Created by William Yeung on 3/17/21.
//

import SwiftUI

class CategoryManager: ObservableObject {
    @Published var categoryName = ""
    @Published var categoryImage = UIImage(named: "placeholder")!
    
    @Published var isEditOn = false
    @Published var isShowingEditingView = false
    @Published var isShowingDeleteAlert = false
}
