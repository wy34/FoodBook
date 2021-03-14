//
//  RecipesBookview.swift
//  FoodManChu
//
//  Created by William Yeung on 3/5/21.
//

import SwiftUI

struct RecipesBookView: View {
    @FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipeName, ascending: true)]) var recipes: FetchedResults<Recipe>
    @StateObject var recipeManager = RecipeManager()
        
    var body: some View {
        NavigationView {
            Form {
                ForEach(Array(groupsByFirstLetter().keys.sorted()), id: \.self) { key in
                    Section(header: Text(String(key))) {
                        ForEach(groupsByFirstLetter()[key]!, id: \.id) { recipe in
                            NavigationLink(destination: BookRecipeDetailView(recipe: recipe, recipeManager: self.recipeManager)) {
                                HStack {
                                    Text(recipe.recipeName ?? "")
                                    Spacer()
                                    Text(recipe.category?.name ?? "")
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                            }
                        }
                    }
                }
            }
                .navigationBarTitle("Recipes Book")
        }
    }
    
    func groupsByFirstLetter() -> [Character: [Recipe]] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        var recipeListGroupedByFirstLetter = [Character: [Recipe]]()
        
        for letter in alphabet {
            for recipe in self.recipes {
                if let firstLetter = recipe.recipeName?.first?.lowercased() {
                    if String(letter) == firstLetter {
                        if var recipeArr = recipeListGroupedByFirstLetter[letter] {
                            recipeArr.append(recipe)
                            recipeListGroupedByFirstLetter[letter] = recipeArr
                        } else {
                            recipeListGroupedByFirstLetter[letter] = [recipe]
                        }
                    }
                }
            }
        }
        
        return recipeListGroupedByFirstLetter
    }
}


struct RecipesBookView_previews: PreviewProvider {
    static var previews: some View {
        RecipesBookView()
    }
}


struct BookRecipeDetailView: View {
    var recipe: Recipe
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var translationHeight: CGFloat = UIScreen.main.bounds.height * 0.25
    @State private var showShareAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var shareResultMessage: (String, String) {
        return cloudKitManager.successfullySavedRecipe ? ("Success", "Refresh, and you should see your post!") : ("Error", "There was an error sharing. Check your network connection or try again.")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(uiImage: UIImage(data: recipe.recipeThumbnail ?? Data())!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
                Spacer()
            }
            
            ZStack {
                RoundedButtonView(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], bgColor: #colorLiteral(red: 0.9480282664, green: 0.9499420524, blue: 0.9704909921, alpha: 1), cornerRadius: 30)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65)
                    .overlay(
                        Capsule()
                            .fill(Color.gray.opacity(0.75))
                            .frame(width: 80, height: 6)
                            .padding(.top, 12.5)
                            .padding(.bottom, 18.5)
                        , alignment: .top
                    )
                    .overlay(
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                Text(recipe.recipeName ?? "")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .font(.custom("TypoRoundBoldDemo", size: 30, relativeTo: .body))

                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text("\(recipeManager.formattedPrepTimeText)")
                                        .font(.custom("TypoRoundLightDemo", size: 18, relativeTo: .body))
                                }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 8)
                                    .background(Color.orange)
                                    .cornerRadius(10)
                                    .padding(.top, 10)
                                    .padding(.bottom, 15)
                                
                                Group {
                                    Text("Description")
                                        .font(.custom("TypoRoundRegularDemo", size: 22, relativeTo: .body))
                                        .underline()
                                        .lineLimit(nil)
                                        .padding(.bottom, 1)
                                    
                                    Text(recipe.recipeDescription ?? "")
                                        .font(.custom("TypoRoundLightDemo", size: 18, relativeTo: .body))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                }
                                
                                HStack {
                                    Spacer()
                                    CustomSegmentedPickerWithMenu(recipeManager: self.recipeManager)
                                    Spacer()
                                }
                                    .padding(.vertical, 30)
                            }
                                .padding(.top, 5)
                                .padding(.horizontal, 25)
                            }
                                .padding(.top, 30)
                        , alignment: .topLeading
                    )
                        .offset(x: 0, y: self.translationHeight)
                        .animation(.easeIn)
                        .gesture(
                            DragGesture()
                                .onChanged({ (value) in
        //                            self.yCoor = value.location.y
        //                            if value.translation.height < 0 {
        //                                if value.location.y > 1000 {
        //                                    self.translationHeight = value.translation.height + UIScreen.main.bounds.height * 0.18
        //                                }
        //                            } else {
        //                                if value.location.y < 110.5 {
        //                                    self.translationHeight = value.translation.height
        //                                }
        //                            }
                                })
                                .onEnded({ (value) in
                                    if value.translation.height <= 0 {
                                        self.translationHeight = 0
                                    } else {
                                        self.translationHeight = UIScreen.main.bounds.height * 0.25
                                    }
                                })
                        )
            }
        }
            .navigationBarTitle("Details", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading:
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    },
                trailing:
                    Button(action: { self.showShareAlert = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                    .alert(isPresented: $showShareAlert) {
                        Alert(title: Text("Share"), message: Text("This will share to the discover page, where all users will be able to see this recipe."), primaryButton: .cancel(), secondaryButton: .default(Text("OK")) {
                            cloudKitManager.createRecipeRecord(recipe: self.recipe)
                        })
                    }
            )
            .alert(isPresented: self.$cloudKitManager.successfullySavedRecipe) {
                Alert(title: Text(shareResultMessage.0), message: Text(shareResultMessage.1), dismissButton: .default(Text("OK")))
            }
            .onAppear() {
                self.recipeManager.recipe = self.recipe
            }
    }
}
