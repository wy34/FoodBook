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
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 35)!)]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 18)!)]
    }
    
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    
    // 10 columns, this spacing is between columns
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200)), count: 2)
    
    @State private var addingNewCategory = false
    @State var menuOpen: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
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
                    .navigationBarTitle("Categories")
                    .navigationBarItems(
                        leading: Button(action: { self.openMenu() }) {
                                    Image(systemName: "line.horizontal.3")
                                        .font(.system(.title, design: .rounded))
                                        .foregroundColor(Color.primary)
                                 },
                        trailing: Button(action: { self.addingNewCategory.toggle() }) {
                                    Image(systemName: "plus")
                                        .font(.system(.title, design: .rounded))
                                        .foregroundColor(Color.primary)
                                  }
                    )
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
