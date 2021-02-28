//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    let screenSize = UIScreen.main.bounds
    
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200)), count: 2) // 10 columns, this spacing is between columns
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, alignment: .center, spacing: 40, content: { // this spacing is between rows
                    ForEach(0..<11) {
                        Image(systemName: "cloud")
                            .frame(width: screenSize.width / 2 - 40, height: screenSize.height / 3)
                            .background(Color($0 % 2 == 0 ? .red : .blue))
                            .cornerRadius(30)
                    }
                })
                    .padding(.horizontal, 20)
            }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
