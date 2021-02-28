//
//  FloatingTabBar.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

struct FloatingTabBar: View {
    // MARK: - Properties
    let screen = UIScreen.main.bounds
    
    @State private var selection = 0
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            Button(action: { self.selection = 0 }) {
                Image(systemName: "house")
                    .foregroundColor(self.selection == 0 ? .white : .black)
                    .frame(width: screen.width / 3)
            }
                        
            Button(action: { self.selection = 1 }) {
                Image(systemName: "book")
                    .frame(width: screen.width / 3)
                    .foregroundColor(self.selection == 1 ? .white : .black)
            }
                        
            Button(action: { self.selection = 2 }) {
                Image(systemName: "globe")
                    .frame(width: screen.width / 3)
                    .foregroundColor(self.selection == 2 ? .white : .black)
            }
        }
            .frame(width: screen.width - 56, height: 50)
            .background(Color.red)
            .cornerRadius(25)
            .padding([.horizontal], 28)
            .padding(.bottom)
    }
}

struct FloatingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBar()
    }
}
