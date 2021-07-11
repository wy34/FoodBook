//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct CategoriesView: View {
    // MARK: - Properties
    @State private var addingNewCategory = false
    @EnvironmentObject var modalManager: ModalManager
    @StateObject var categoryManager = CategoryManager()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                CategoryGrid(categoryManager: self.categoryManager)
                
                if !self.categoryManager.isEditOn {
                    Button(action: { self.addingNewCategory = true }) {
                        Image(systemName: SFSymbols.plus)
                            .font(.system(.title))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.075, height: UIScreen.main.bounds.width * 0.075)
                            .padding()
                            .background(Color.mainGreen)
                            .clipShape(Circle())
                    }
                        .padding(.bottom, 20)
                        .padding(.trailing, 20)
                }
            }
                .navigationBarTitle("Categories")
                .navigationBarItems(trailing:
                    Button(action: { self.categoryManager.isEditOn.toggle() }) {
                        Text(self.categoryManager.isEditOn  ? "Done" : "Edit")
                            .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                            .foregroundColor(self.categoryManager.isEditOn  ? .lightRed : .black)
                    })
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: self.$addingNewCategory) {
                AddEditCategoryView(categoryManager: CategoryManager())
            }
            .onDisappear() {
                self.categoryManager.isEditOn = false
            }
    }
}
