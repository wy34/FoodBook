//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct ContentView: View {
    // changing font of navbar
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 38)!)]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 18)!)]
    }
    
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    
    @State private var addingNewCategory = false
    @State var menuOpen: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            NavigationView {
                ZStack(alignment: .bottomTrailing) {
                    // Scrolling Categories
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                            ForEach(0..<10) { i in
                                NavigationLink(destination: RecipeView()) {
                                    Image(systemName: "cloud)")
                                        .frame(width: screenSize.width - 30, height: 200)
                                        .background(Color(i % 2 == 0 ? .blue : .red))
                                        .cornerRadius(30)
                                }
                            }
                        })
                            .padding(.top, 15)
                            .navigationBarTitle("Categories")
                            .navigationBarItems(leading:
                                Button(action: { self.openMenu() }) {
                                    Image(systemName: "line.horizontal.3")
                                        .font(.system(.title, design: .rounded))
                                        .foregroundColor(Color.primary)
                                }
                            )
                    }
                    
                    // Add New Category Button
                    Button(action: { self.addingNewCategory.toggle() }) {
                        Image(systemName: "plus")
                            .frame(width: screenSize.width * 0.1, height: screenSize.width * 0.1)
                            .font(.system(.largeTitle, design: .rounded))
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                        .padding(.bottom, 20)
                        .padding(.trailing, 15)
                        .shadow(color: Color.black.opacity(0.75), radius: 15, x: 5, y: 5)
                }
            }
                .offset(x: menuOpen ? 250 : 0)
                .animation(.default, value: menuOpen)
                .sheet(isPresented: $addingNewCategory) {
                    AddCategoryView()
                }
            
            Menu(width: 250, isOpen: self.menuOpen, menuClose: self.openMenu)
        }
    }
    
    // MARK: - Helpers
    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
