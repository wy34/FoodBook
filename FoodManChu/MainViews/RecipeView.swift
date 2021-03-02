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
            ScrollView(showsIndicators: false) {
                // this spacing is between rows
                LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                    ForEach(0..<11) { i in
                        Image(systemName: "cloud")
                            .frame(width: screenSize.width / 2 - 25, height: screenSize.height / 4)
                            .background(Color(.red))
                            .cornerRadius(30)
                            .onTapGesture {
                                self.modalManager.isRecipeDetailViewShowing = true
                            }
                    }
                })
                    .padding(.horizontal, 12)
                .padding(.vertical, 15)
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
            
            if modalManager.isRecipeDetailViewShowing {
                CustomModalView(content: Color.blue)
                    .animation(Animation.easeInOut(duration: 0.4))
            }
        }
            .onDisappear() {
                self.modalManager.isRecipeDetailViewShowing = false
            }
    }
}

// MARK: - Preview
struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(ModalManager())
    }
}
