//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/1/21.
//

import SwiftUI

// MARK: - RecipeDetailView
struct RecipeDetailView: View {
    let screenSize = UIScreen.main.bounds
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeManager: RecipeManager

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
                    .font(.custom("TypoRoundBoldDemo", size: 28, relativeTo: .body))
                
                HStack {
                    self.recipeManager.formattedPrepTimeText
                        .font(.custom("TypoRoundLightDemo", size: 18, relativeTo: .body))
                        .cornerRadius(5)
                    Divider()
                        .background(Color.black)
                        .frame(width: 1, height: 15)
                    Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1))
                        .frame(width: 45, height: 30)
                        .cornerRadius(5)
                }
                    .padding(.bottom, 15)
                
                Divider()
                    .background(Color.black.opacity(0.2))
                
                // Description
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.custom("TypoRoundRegularDemo", size: 22, relativeTo: .body))
                        .underline()
                        .padding(.bottom, 1)
                    
                    Text(self.recipeManager.recipeDescription)
                        .font(.custom("TypoRoundLightDemo", size: 18, relativeTo: .body))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                
                CustomSegmentedPickerWithMenu(recipeManager: self.recipeManager)
                
                Spacer()
            }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
        }
    }
}
