//
//  SearchBar.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    @State private var isSearching = false
 
    var body: some View {
        HStack(spacing: 0) {
            TextField("Search categories", text: $searchText)
                .padding(.leading, 25)
                .padding(.trailing, self.isSearching ? 25 : 0)
                .padding(9)
                .background(Color(.lightGray))
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Spacer()
                        if self.isSearching && !self.searchText.isEmpty {
                            Button(action: { self.searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(Color(#colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998806119, alpha: 1)))
                            }
                        }
                    }
                    .padding(.horizontal, 9)
                )
                .onTapGesture {
                    self.isSearching = true
                }
                .cornerRadius(12)
            
            if isSearching {
                Button(action: {
                    self.isSearching = false
                    self.searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .padding(.horizontal, 10)
                }
            }
        }
            .padding(.horizontal, 15)
            .animation(Animation.easeOut)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .preferredColorScheme(.dark)
    }
}
