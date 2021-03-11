//
//  DiscoverMoreView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct DiscoverMoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var pickerSelection = 0
    var selections = ["Ingredients", "Instructions"]
    
    let defaultIngredients = [
        "Chicken", "Beef", "Pork", "Broccoli", "Apple", "Orange", "Onion", "Pepper", "Salt", "Water", "Sugar", "Vinegar", "Milk", "Flour", "Cheese", "Eggs", "Tomato", "Potato", "Butter", "Chocolate", "Ketchup", "Olive Oil", "Rice", "Garlic", "Bread", "Carrot", "Celery", "Cinnamin", "Vanilla", "Corn", "Shrimp", "Fish", "Spinich", "Pasta", "Lemon", "Honey", "Beef Broth", "Rosemary", "Green Beans", "Lettuce", "Cabbage", "Bacon", "Mushroom", "Soy Sauce", "Banana", "Oats", "Yogurt", "Whip Cream", "Baking Soda", "Hot Dog"
    ]
    
    let defaultInstructions = [
        "Instruction 1",
        "Instruction 1",
        "Instruction 1",
        "Instruction 1",
        "Instruction 1",
        "Instruction 1"
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 80)
                    
                    if self.pickerSelection == 0 {
                        ForEach(defaultIngredients, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient)
                                Spacer()
                                Text("2 cups")
                            }
                                .padding()
                                .background(Color(#colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1)))
                        }
                            .cornerRadius(10)
                    } else {
                        ForEach(defaultInstructions, id: \.self) { instruction in
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
                .navigationBarTitle("General Tso's Chicken", displayMode: .inline)
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
    }
}

struct DiscoverMoreView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverMoreView()
    }
}
