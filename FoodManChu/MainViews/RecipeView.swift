//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct RecipeView: View {
    // MARK: - Properties
    // 2 columns, this spacing is between columns
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200), spacing: 15), count: 2)
    let screenSize = UIScreen.main.bounds
    
    @EnvironmentObject var modalManager: ModalManager
    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body
    var body: some View {
        ZStack {
            RecipeGrid()

            if modalManager.isRecipeDetailViewShowing {
                CustomModalView(content: RecipeDetailView())
                    .animation(Animation.easeInOut(duration: 0.4))
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

// MARK: - Preview
struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(ModalManager())
    }
}

struct RecipeGrid: View {
    // 2 columns, this spacing is between columns
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200), spacing: 15), count: 2)
    let screenSize = UIScreen.main.bounds
    @EnvironmentObject var modalManager: ModalManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                SearchBar(placeholder: "Search Recipes")
                    .padding(.top, 10)
                    .padding(.horizontal, 5)
                
                // this spacing is between rows
                LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                    ForEach(0..<11) { i in
                        Button(action: { self.modalManager.isRecipeDetailViewShowing = true }) {
                            Image(systemName: "cloud")
                                .frame(width: screenSize.width / 2 - 35, height: screenSize.height / 4)
                                .background(Color(.red))
                                .cornerRadius(30)
                        }
                    }
                })
                    .padding(15)
            }
                .navigationBarTitle("Meat", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: // have to put in here otherwise won't show in navbar
                                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                )
                .onDisappear() {
                    self.modalManager.isRecipeDetailViewShowing = false
                }
        }
    }
}
