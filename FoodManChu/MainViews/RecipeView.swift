//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct RecipeView: View {
    let screenSize = UIScreen.main.bounds

    // 2 columns, this spacing is between columns
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200)), count: 2)
    var body: some View {
        ScrollView {
            // this spacing is between rows
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 40, content: {
                ForEach(0..<11) { i in
                    NavigationLink(destination: RecipeView()) {
                        Image(systemName: "cloud")
                            .frame(width: screenSize.width / 2 - 40, height: screenSize.height / 3)
                            .background(Color(.red))
                            .cornerRadius(30)
                    }
                }
            })
                .padding([.vertical, .horizontal], 20)
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}
