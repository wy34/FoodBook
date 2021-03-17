//
//  RecipesBookview.swift
//  FoodManChu
//
//  Created by William Yeung on 3/5/21.
//

import SwiftUI

// MARK: - RecipesBookView
struct RecipesBookView: View {
    @FetchRequest(entity: Recipe.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.recipeName, ascending: true)]) var recipes: FetchedResults<Recipe>
    @StateObject var recipeManager = RecipeManager()
       
    var body: some View {
        NavigationView {
            Form {
                if recipes.isEmpty {
                    HStack {
                        Spacer()
                        Text("No recipes. Add one in the Builder view or save one from the Discover page to enable convenient access here.")
                            .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .padding(.top, 35)
                        Spacer()
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.952141583, green: 0.9497230649, blue: 0.9704508185, alpha: 1)))
                } else {
                    ForEach(Array(groupsByFirstLetter().keys.sorted()), id: \.self) { key in
                        Section(header: Text(String(key)).font(.custom("Comfortaa-Bold", size: 12, relativeTo: .body))) {
                            ForEach(groupsByFirstLetter()[key]!, id: \.id) { recipe in
                                NavigationLink(destination: BookRecipeDetailView(recipe: recipe, recipeManager: self.recipeManager)) {
                                    HStack {
                                        Text(recipe.recipeName ?? "")
                                            .font(.custom("Comfortaa-Bold", size: 16, relativeTo: .body))
                                        Spacer()
                                        Text(recipe.category?.name ?? "")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 8)
                                            .font(.custom("Comfortaa-Medium", size: 14, relativeTo: .body))
                                            .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                            .onDelete(perform: { offsets in
                                self.delete(at: offsets, category: key)
                            })
                        }
                    }
                }
            }
                .navigationBarTitle("Recipe Book")
        }
            .navigationViewStyle(StackNavigationViewStyle())
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
    
    func delete(at offsets: IndexSet, category: Character) {
        // have to pass in the specific category in order to delete from the correct section
        for offset in offsets {
            let recipe = groupsByFirstLetter()[category]![offset]
            PersistenceController.shared.delete(recipe)
            PersistenceController.shared.save()
        }
    }
}


// MARK: - BookRecipeDetailView
struct BookRecipeDetailView: View {
    var recipe: Recipe
    
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var translationHeight: CGFloat = UIScreen.main.bounds.height * 0.25
    @State private var showShareAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var shareResultMessage: (String, String) {
        return cloudKitManager.finishedTask && cloudKitManager.successfullySavedRecipe ? ("Success", "Refresh, and you should see your post!") : ("Error", "Make sure you are connected to a network and/or signed into an iCloud account in order to share.")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(uiImage: UIImage(data: recipe.recipeThumbnail ?? Data())!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.45)
                    .clipped()
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
                                    .font(.custom("Comfortaa-Bold", size: 28, relativeTo: .body))

                                
                                HStack {
                                    Image(systemName: "clock")
                                    Text("\(recipeManager.formattedPrepTimeText)")
                                        .font(.custom("comfortaa-light", size: 16, relativeTo: .body))
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
                                        .font(.custom("Comfortaa-Medium", size: 18, relativeTo: .body))
                                        .underline()
                                        .lineLimit(nil)
                                        .padding(.bottom, 1)
                                    
                                    Text(recipe.recipeDescription ?? "")
                                        .font(.custom("comfortaa-light", size: 15, relativeTo: .body))
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
                            .imageScale(.medium)
                            .foregroundColor(.black)
                    },
                trailing:
                    Button(action: { self.showShareAlert = true }) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.medium)
                            .foregroundColor(.black)
                    }
                    .alert(isPresented: $showShareAlert) {
                        Alert(title: Text("Share"), message: Text("This will share to the discover page, where all users will be able to see this recipe."), primaryButton: .cancel(), secondaryButton: .default(Text("OK")) {
                            cloudKitManager.createRecipeRecord(recipe: self.recipe)
                        })
                    }
            )
            .alert(isPresented: self.$cloudKitManager.finishedTask) {
                Alert(title: Text(shareResultMessage.0), message: Text(shareResultMessage.1), dismissButton: .default(Text("OK")))
            }
            .onAppear() {
                self.recipeManager.recipe = self.recipe
            }
    }
}
