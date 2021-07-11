//
//  CategoryCell.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct CategoryCell: View {
    // MARK: - Properties
    var category: Category
    let screenSize = UIScreen.main.bounds
    @Binding var isEditing: Bool
    @StateObject var categoryManager = CategoryManager()
    
    // MARK: - Body
    var body: some View {
        if let thumbnailData = category.thumbnail {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .topTrailing) {
                    NavigationLink(destination: RecipeView(category: self.category)) {
                        Image(uiImage: UIImage(data: thumbnailData)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenSize.width - 40, height: 200)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 10, y: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black.opacity(self.isEditing ? 0.5 : 0.3))
                                    .overlay(
                                        Text(category.name ?? "")
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.center)
                                            .font(.custom(FBFont.bold, size: 40, relativeTo: .body))
                                            .foregroundColor(self.isEditing ? Color(.systemGray2) : .white)
                                            .background(Color.clear)
                                            .padding(.horizontal, 20)
                                            .minimumScaleFactor(0.5)
                                    )
                            )
                    }
                        .disabled(self.isEditing ? true : false)
                    
                    if self.isEditing {
                        Button(action: {
                            self.categoryManager.categoryName = self.category.name ?? ""
                            self.categoryManager.categoryImage = UIImage(data: self.category.thumbnail ?? Data()) ?? Assets.food
                            self.categoryManager.isShowingEditingView = true
                        }) {
                            RoundedButtonView(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner], bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6499315956), cornerRadius: 20)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: SFSymbols.pencilCircle)
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
                
                if self.isEditing {
                    Button(action: { self.categoryManager.isShowingDeleteAlert = true }) {
                        RoundedButtonView(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], bgColor: #colorLiteral(red: 1, green: 0.4903432131, blue: 0.4654182792, alpha: 0.7518001152), cornerRadius: 20)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: SFSymbols.trash)
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
                .animation(.easeIn)
                .fullScreenCover(isPresented: self.$categoryManager.isShowingEditingView) {
                    AddEditCategoryView(category: self.category, categoryManager: categoryManager)
                }
                .alert(isPresented: $categoryManager.isShowingDeleteAlert) {
                    Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this category? Doing so will delete all associated recipes."), primaryButton: .cancel(), secondaryButton: .default(Text("Yes")) {
                            self.delete()
                        }
                    )
                }
        }
    }
    
    // MARK: - Helpers
    private func delete() {
        for recipe in category.recipe?.allObjects as! [Recipe] {
            PersistenceController.shared.delete(recipe)
        }
        PersistenceController.shared.delete(category)
        PersistenceController.shared.save()
    }
}
