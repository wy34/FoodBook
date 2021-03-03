//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct CategoriesView2: View {
    // MARK: - Properties
    @State private var addingNewCategory = false
    @EnvironmentObject var modalManager: ModalManager
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationView {
                CategoryGrid()
            }
            
            if !modalManager.isRecipeDetailViewShowing {
                HoveringButtonWithMenu()
                    .padding(.bottom, 15)
                    .padding(.trailing, 15)
            }
        }
    }
    
    // MARK: - Helpers
    func onSearch(searchText: String) {
        print(searchText)
    }
    
    func onCancel() {
        print("cancel")
    }
}

// MARK: - Previews
struct CategoriesView2_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView2()
            .environmentObject(ModalManager())
            .preferredColorScheme(.light)
    }
}


struct CategoryGrid: View {
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SearchBar(placeholder: "Search Categories")
                .padding(.top, 10)
                .padding(.horizontal, 5)
            
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                ForEach(0..<15) { i in
                    NavigationLink(destination: RecipeView()) {
                        Image(systemName: "cloud")
                            .frame(width: screenSize.width - 40, height: 200)
                            .background(Color(i % 2 == 0 ? .blue : .red))
                            .cornerRadius(30)
                    }
                }
            })
                .padding(.top, 15)
                .padding(.bottom, 15)
        }
            .navigationBarTitle("Categories")
    }
}
