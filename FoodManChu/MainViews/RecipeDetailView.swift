//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/1/21.
//

import SwiftUI

struct RecipeDetailView: View {
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeManager: RecipeManager

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: self.recipeManager.recipeImage)
                    .resizable()
                    .frame(width: screenSize.width * 0.45, height: screenSize.width * 0.45)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .shadow(color: Color.black, radius: 10)
                    )
                    
                Text(self.recipeManager.recipeName)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                    .lineLimit(nil)
                    .font(.custom(FBFont.bold, size: 26, relativeTo: .body))
                
                HStack {
                    Spacer()
                    
                    Text(self.recipeManager.recipe!.category?.name ?? "")
                        .font(.custom(FBFont.medium, size: 16, relativeTo: .body))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.mainGreen)
                        .cornerRadius(8)

                    Divider()
                        .background(Color.black)
                        .frame(width: 1, height: 15)
                    
                    HStack {
                        Image(systemName: SFSymbols.clock)
                        self.recipeManager.formattedPrepTimeText
                            .font(.custom(FBFont.medium, size: 16, relativeTo: .body))
                    }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.orange)
                        .cornerRadius(8)
                    
                    Spacer()
                }
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color.black.opacity(0.2))
                
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.custom(FBFont.medium, size: 20, relativeTo: .body))
                        .underline()
                        .padding(.bottom, 1)
                    
                    Text(self.recipeManager.recipeDescription)
                        .font(.custom(FBFont.light, size: 16, relativeTo: .body))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                
                CustomSegmentedPickerWithMenu(recipeManager: self.recipeManager)
                
                Spacer()
            }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
        }
    }
}
