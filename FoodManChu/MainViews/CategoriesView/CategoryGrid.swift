//
//  CategoryGrid.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct CategoryGrid: View {
    // MARK: - Properties
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    @StateObject var categoryManager: CategoryManager
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    @EnvironmentObject var persistenceController: PersistenceController
    @State private var searchText = ""
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SearchBar(placeholder: "Search Categories", searchText: $searchText)
                .padding(.top, 10)
                .padding(.horizontal, 5)
            
            if categories.isEmpty {
                Text("No categories. Press the green plus button to start adding one.")
                    .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .padding(.top, 75)
            } else {
                LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                    ForEach(categories.filter({ $0.name!.lowercased().contains(searchText.lowercased()) || searchText.isEmpty }), id: \.self) { category in
                        CategoryCell(category: category, isEditing: self.$categoryManager.isEditOn)
                    }
                })
                    .padding(.top, 15)
                    .padding(.bottom, 15)
            }
        }
    }
}
