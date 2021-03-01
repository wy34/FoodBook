//
//  ExpandingSearchBar.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct NavigationBarWithExpandingSearchBar: View {
    // MARK: - Properties
    @State private var show = false
    @State private var txt = ""
    
    // MARK: - Body
    var body: some View {
        HStack {
            if show == false {
                Text("Categories")
                    .fontWeight(.bold)
                    .font(.custom("TypoRoundBoldDemo", size: 40, relativeTo: .body))
                    .foregroundColor(.white)
            }
            
            Spacer(minLength: 0)
            
            HStack {
                if self.show {
                    Image(systemName: "magnifyingglass")
                        .padding(.horizontal, 5)
                    
                    TextField("Search Categories", text: $txt)
                        .background(Color.red)
                    
                    Button(action: {  self.show = false; self.txt = "" }) {
                        Image(systemName: "xmark")
                    }
                    .padding(.horizontal, 5)
                } else {
                    Button(action: { self.show = true }) {
                        Image(systemName: "magnifyingglass")
                            .padding(10)
                    }
                }
            }
                .foregroundColor(.black)
                .padding(self.show ? 10 : 2)
                .background(Color.white)
                .cornerRadius(20)
        }
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width, height: 60)
            .padding(.top, 55)
            .padding(.bottom, 10)
            .background(Color.orange)
            .animation(.default)
    }
}

// MARK: - Preview
struct NavigationBarWithExpandingSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarWithExpandingSearchBar()
            .preferredColorScheme(.dark)
    }
}