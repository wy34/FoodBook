//
//  DiscoverMoreView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct DiscoverMoreView: View {
    @State private var pickerSelection = 0
    var selections = ["Ingredients", "Instructions"]
    
    var body: some View {
        Picker("", selection: $pickerSelection) {
            ForEach(0..<selections.count, id: \.self) { i in
                Text(selections[i])
            }
        }
            .pickerStyle(SegmentedPickerStyle())
            .padding(5)
            .background(Color(#colorLiteral(red: 0.6970165372, green: 0.7750255466, blue: 0.9293276668, alpha: 1)))
            .cornerRadius(10)
            .padding()
    }
}

struct DiscoverMoreView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverMoreView()
    }
}
