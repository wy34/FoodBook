//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct CategoriesView2: View {
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    
    @State private var addingNewCategory = false
    @EnvironmentObject var modalManager: ModalManager
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBarWithExpandingSearchBar()
                    
                    // Scrolling Categories
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                            ForEach(0..<5) { i in
                                NavigationLink(destination: RecipeView()) {
                                    Image(systemName: "cloud")
                                        .frame(width: screenSize.width - 30, height: 200)
                                        .background(Color(i % 2 == 0 ? .blue : .red))
                                        .cornerRadius(30)
                                }
                            }
                        })
                            .padding([.top, .bottom], 15)
                    }
                }
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.top)
            }
            
            if !modalManager.isRecipeDetailViewShowing {
                HoveringButtonWithMenu()
                    .padding(.bottom, 20)
                    .padding(.trailing, 15)
            }
        }
    }
}

// MARK: - Previews
struct CategoriesView2_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView2()
            .environmentObject(ModalManager())
            .preferredColorScheme(.light)
    }
}
