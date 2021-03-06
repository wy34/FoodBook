//
//  RecipesBookview.swift
//  FoodManChu
//
//  Created by William Yeung on 3/5/21.
//

import SwiftUI

struct RecipesBookView: View {
    var rawData = [
        "XYZ Fried Rice",
        "Beef with Broccoli",
        "General Tso's Chicken",
        "Garlic Chicken"
    ]
    
    @State private var wordGroups = ["g": ["General Tso\'s Chicken", "Garlic Chicken"], "b": ["Beef with Broccoli"], "x": ["XYZ Fried Rice"]]
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(placeholder: "Recipe")
                    .padding(.bottom, 5)
                Form {
                    ForEach(Array(wordGroups.keys).sorted(), id: \.self) { key in
                        Section(header: Text(key)) {
                            ForEach(wordGroups[key]!, id: \.self) { food in
                                NavigationLink(destination: Text("Hello")) {
                                    Text(food)
                                }
                            }
                        }
                    }
                }
            }
                .navigationBarTitle("Recipes Book")
        }
    }
    
    func getAllFirstLetterGroups() -> [String: [String]] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var sameStartingLetterDict = [String: [String]]()
        
        for letter in alphabet {
            for data in rawData {
                if let firstLetter = data.first {
                    if firstLetter.lowercased() == String(letter) {
                        let key = String(letter)
                
                        if sameStartingLetterDict[key] != nil {
                            sameStartingLetterDict[key]?.append(data)
                        } else {
                            sameStartingLetterDict[key] = [data]
                        }
                    }
                }
            }
        }
        
        print("Dictionary: \(sameStartingLetterDict)")
        print("Keys: \(sameStartingLetterDict.keys)")

        return sameStartingLetterDict
    }
}


struct RecipesBookView_previews: PreviewProvider {
    static var previews: some View {
        RecipesBookView()
    }
}
