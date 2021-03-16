//
//  CategoryPickerView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/3/21.
//

import SwiftUI


// MARK: - CategoryPickerView
struct CategoryPickerView: View {
    let cats = ["Meat", "Vegan", "Vegetarian"]
    @Binding var selectedCategory: Int
    @Binding var isShowingPicker: Bool
    @State private var searchText = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            SearchBar(placeholder: "Category", searchText: $searchText)
                .padding(.top, 25)
                .padding(.bottom, 10)

            ForEach(0..<cats.count) { i in
                VStack {
                    Button(action: { self.selectedCategory = i; self.isShowingPicker.toggle() }) {
                        HStack {
                            Text(cats[i])
                                .font(.custom("Comfortaa-Bold", size: 16, relativeTo: .body))
                            Spacer()
                            Image(systemName: self.selectedCategory == i ? "checkmark" : "")
                        }
                            .foregroundColor(.primary)
                            .padding(12)
                    }

                    if i != 99 {
                        Divider()
                    }
                }
            }
                .padding(.horizontal, 15)
        }
            .padding(.horizontal, 14)
            .navigationBarTitle("", displayMode: .inline)
    }
}


struct CategoryPickerView_previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerView(selectedCategory: .constant(0), isShowingPicker: .constant(true)).preferredColorScheme(.dark)
    }
}
