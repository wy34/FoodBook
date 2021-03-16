//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct RootView: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor.white
    }
    
    // MARK: - Body
    var body: some View {
        TabView {
            RecipesBookView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Book")
                }
            CategoriesView()
                .tabItem {
                    Image(systemName: "hammer")
                    Text("Builder")
                        
                }
            Discover()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Discover")
                }
        }
            .accentColor(Color(#colorLiteral(red: 0.4468465447, green: 0.6117238402, blue: 0.4210793078, alpha: 1)))
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModalManager())
    }
}
