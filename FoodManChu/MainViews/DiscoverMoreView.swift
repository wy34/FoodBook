//
//  DiscoverMoreView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct DiscoverMoreView: View {
    var recipeRecord: RecipeRecord
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    @State private var pickerSelection = 0
    var selections = ["Ingredients", "Instructions"]

    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 80)
                    
                    if self.pickerSelection == 0 {
                        ForEach(0..<self.cloudKitManager.ingredients.count, id: \.self) { i in
                            HStack {
                                Text(self.cloudKitManager.ingredients[i].ingredientName)
                                Spacer()
                                Text(self.cloudKitManager.ingredients[i].ingredientAmount)
                            }
                                .padding()
                                .background(Color(#colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1)))
                        }
                            .cornerRadius(10)
                    } else {
                        ForEach(self.cloudKitManager.instructions, id: \.self) { instruction in
                            HStack {
                                Text(instruction)
                                    .padding(.horizontal)
                                Spacer()
                            }
                                .padding(.vertical)
                                .background(Color(#colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1)))
                        }
                            .cornerRadius(10)
                    }
                }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .font(.custom("TypoRoundRegularDemo", size: 18, relativeTo: .body))
            }
                .navigationBarTitle(recipeRecord.recipeName, displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                    }
                )

            Picker("", selection: $pickerSelection) {
                ForEach(0..<selections.count, id: \.self) { i in
                    Text(selections[i])
                }
            }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: UIScreen.main.bounds.width * 0.87)
                .padding(5)
                .background(Color(#colorLiteral(red: 0.8968909383, green: 0.9103438258, blue: 0.9443851113, alpha: 1)))
                .cornerRadius(10)
                .padding(.top)
        }
            .onAppear() {
                self.cloudKitManager.fetchIngredientsFor(recipeRecord: self.recipeRecord)
                self.cloudKitManager.fetchInstructionsFor(recipeRecord: self.recipeRecord)
            }
    }
}
