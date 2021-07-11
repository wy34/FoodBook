//
//  CategoryManager.swift
//  FoodManChu
//
//  Created by William Yeung on 3/17/21.
//

import SwiftUI

class CategoryManager: ObservableObject {
    // MARK: - Properties
    @Published var categoryName = ""
    @Published var categoryImage = Assets.placeholder
    
    @Published var isEditOn = false
    @Published var isShowingEditingView = false
    @Published var isShowingDeleteAlert = false
}
