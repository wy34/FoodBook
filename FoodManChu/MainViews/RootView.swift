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
            CategoriesView2()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            Color.red
                .tabItem {
                    Image(systemName: "book")
                    Text("Home")
                }
            Color(.red)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Home")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(ModalManager())
    }
}
