//
//  DiscoverCell.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct DiscoverCell: View {
    // MARK: - Properties
    var recipeRecord: RecipeRecord
    
    var formattedTimeLabel: Text {
        if recipeRecord.timeHour == 0.0 {
            return Text("\(recipeRecord.timeMinute, specifier: "%.0f")m")
        } else {
            return Text("\(recipeRecord.timeHour, specifier: "%.0f")h \(recipeRecord.timeMinute, specifier: "%.0f")m")
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(uiImage: recipeRecord.recipeImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(recipeRecord.recipeName)
                    .lineLimit(nil)
                    .font(.custom(FBFont.bold, size: 22, relativeTo: .body))
                    .foregroundColor(.black)
                    .padding(.top, 12)
                
                HStack {
                    Text(recipeRecord.recipeCategory)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.mainGreen)
                        .cornerRadius(8)

                    Divider()
                        .background(Color.black)
                        .frame(width: 1, height: 15)
                    
                    HStack {
                        Image(systemName: SFSymbols.clock)
                        formattedTimeLabel
                    }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.orange)
                        .cornerRadius(8)
                    
                    Spacer()
                }
                    .foregroundColor(.white)
                    .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
                    .padding(.top, 5)
                
                Text(recipeRecord.recipeDescription)
                    .font(.custom(FBFont.medium, size: 16, relativeTo: .body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .foregroundColor(Color(.darkGray))
                    .padding(.bottom, 8)
                    .padding(.top, 8)
            }
                .padding(.horizontal, 8)
        }
    }
}
