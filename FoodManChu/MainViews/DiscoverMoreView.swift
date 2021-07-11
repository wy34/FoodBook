//
//  DiscoverMoreView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct DiscoverMoreView: View {
    // MARK: - Properties
    var recipeRecord: RecipeRecord
    var selections = ["Ingredients", "Instructions"]
    
    @State private var pickerSelection = 0
    @State private var showSheet = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer(minLength: 80)
                    
                    if self.pickerSelection == 0 {
                        ForEach(0..<self.cloudKitManager.ingredients.count, id: \.self) { i in
                            HStack {
                                Text(self.cloudKitManager.ingredients[i].ingredientName)
                                    .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
                                Spacer()
                                Text(self.cloudKitManager.ingredients[i].ingredientAmount)
                                    .font(.custom(FBFont.medium, size: 12, relativeTo: .body))
                            }
                                .padding()
                                .background(Color(#colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1)))
                        }
                            .cornerRadius(10)
                    } else {
                        ForEach(self.cloudKitManager.instructions, id: \.self) { instruction in
                            HStack {
                                Text(instruction)
                                    .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
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
                    .font(.custom(FBFont.medium, size: 16, relativeTo: .body))
            }
                .navigationBarTitle(recipeRecord.recipeName, displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: SFSymbols.arrowLeft)
                            .imageScale(.medium)
                    },
                    trailing:
                    Button(action: {
                        self.showSheet = true
                    }) {
                        Image(systemName: SFSymbols.icloudArrowDown)
                            .imageScale(.medium)
                    }
                )
                    .unredacted()

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
                .disabled(self.cloudKitManager.ingredients.isEmpty)
        }
            .redacted(reason: self.cloudKitManager.ingredients.isEmpty ? .placeholder : [])
            .sheet(isPresented: $showSheet) {
                CategoryPickerView(recipeRecord: self.recipeRecord)
                    .environmentObject(self.cloudKitManager)
                    .environment(\.managedObjectContext, self.moc)
            }
            .onAppear() {
                self.cloudKitManager.fetchIngredientsFor(recipeRecord: self.recipeRecord)
                self.cloudKitManager.fetchInstructionsFor(recipeRecord: self.recipeRecord)
            }
    }
}
