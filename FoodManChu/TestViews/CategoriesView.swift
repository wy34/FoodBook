//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct CategoriesView: View {
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    
    @State private var addingNewCategory = false
    @State private var isNavBarHidden = true
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                NavigationBarWithExpandingSearchBar()
                
                ZStack(alignment: .bottomTrailing) {
                    // Scrolling Categories
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                            ForEach(0..<10) { i in
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
                    
                    // Add New Category Button
                    Button(action: { self.addingNewCategory.toggle() }) {
                        Image(systemName: "plus")
                            .frame(width: screenSize.width * 0.08, height: screenSize.width * 0.08)
                            .font(.system(.largeTitle, design: .rounded))
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                        .padding(.bottom, 20)
                        .padding(.trailing, 16)
                        .shadow(color: Color.black.opacity(0.75), radius: 15, x: 5, y: 5)
                        .sheet(isPresented: $addingNewCategory) {
                            AddCategoryView()
                        }
                }
            }
                .navigationBarHidden(self.isNavBarHidden)
                .edgesIgnoringSafeArea(.top)
                .onAppear() {
                    self.isNavBarHidden = true
                }
        }
    }
}

// MARK: - Previews
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .preferredColorScheme(.light)
    }
}
