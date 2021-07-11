//
//  CircularCategoryView.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct CircularCategoryView: View {
    // MARK: - Properties
    var category: Category
    let screenSize = UIScreen.main.bounds
    @Binding var tappedCategory: Category?
    @ObservedObject var categoryManager: CategoryManager

    // MARK: - Body
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Circle()
                    .stroke(self.tappedCategory == category ? Color.blue : Color.clear, lineWidth: 3)
                    .frame(width: screenSize.width * 0.3 - 15, height: screenSize.width * 0.3 - 15)
                Button(action: {
                    self.categoryManager.categoryName = ""
                    self.categoryManager.categoryImage = Assets.placeholder
                    tappedCategory = self.category
                }) {
                    Image(uiImage: UIImage(data: category.thumbnail!)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.width * 0.3 - 20, height: screenSize.width * 0.3 - 20)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                }
                    .overlay(
                        Image(systemName: SFSymbols.checkmark)
                            .foregroundColor(self.tappedCategory == category ? .white : .clear)
                            .frame(width: 28, height: 28)
                            .background(tappedCategory == category ? Color.blue : Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        , alignment: .bottomTrailing
                    )
            }
            
            Text(category.name!)
                .multilineTextAlignment(.center)
                .frame(width: screenSize.width < 375 ? screenSize.width * 0.3 : screenSize.width * 0.25)
        }
    }
}
