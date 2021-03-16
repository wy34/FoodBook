//
//  SearchBar.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct SearchBar: View {
    var placeholder: String
    
    @Binding var searchText: String
    @State private var isSearching = false
    
 
    var body: some View {
        HStack(spacing: 0) {
            TextField(placeholder, text: $searchText)
                .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                .padding(.leading, 28)
                .padding(.trailing, self.isSearching ? 25 : 0)
                .padding(6)
                .background(Color(.systemGray5))
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Spacer()
                        if self.isSearching && !self.searchText.isEmpty {
                            Button(action: { self.searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.secondary)
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
                        .font(.custom("Comfortaa-Bold", size: 12, relativeTo: .body))
                        .padding(.horizontal, 10)
                }
            }
        }
            .padding(.horizontal, 15)
            .animation(Animation.easeOut, value: self.isSearching)
    }
}
