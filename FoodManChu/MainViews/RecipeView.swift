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
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200)), count: 2)
    let screenSize = UIScreen.main.bounds

    @Binding var isNavBarHidden: Bool
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            // this spacing is between rows
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 40, content: {
                ForEach(0..<11) { i in
                    NavigationLink(destination: RecipeDetailView()) {
                        Image(systemName: "cloud")
                            .frame(width: screenSize.width / 2 - 40, height: screenSize.height / 3)
                            .background(Color(.red))
                            .cornerRadius(30)
                    }
                }
            })
                .padding([.vertical, .horizontal], 20)
        }
            .navigationBarTitle("Meat Recipes", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 25, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
                }
            )
            .onAppear {
                self.isNavBarHidden = false
            }
    }
}

// MARK: - Preview
struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(isNavBarHidden: .constant(false))
    }
}
