//
//  BookRecipeDetailView.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct BookRecipeDetailView: View {
    // MARK: - Properties
    var recipe: Recipe
    
    @ObservedObject var recipeManager: RecipeManager
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var translationHeight: CGFloat = UIScreen.main.bounds.height * 0.25
    @State private var showShareAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var shareResultMessage: (String, String) {
        return cloudKitManager.finishedTask && cloudKitManager.successfullySavedRecipe ? ("Success", "Refresh, and you should see your post!") : ("Error", "Make sure you are connected to a network and/or signed into an iCloud account in order to share.")
    }

    // MARK: - Body
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
                                    .font(.custom(FBFont.bold, size: 28, relativeTo: .body))

                                
                                HStack {
                                    Image(systemName: SFSymbols.clock)
                                    Text("\(recipeManager.formattedPrepTimeText)")
                                        .font(.custom(FBFont.light, size: 16, relativeTo: .body))
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
                                        .font(.custom(FBFont.medium, size: 18, relativeTo: .body))
                                        .underline()
                                        .lineLimit(nil)
                                        .padding(.bottom, 1)
                                    
                                    Text(recipe.recipeDescription ?? "")
                                        .font(.custom(FBFont.light, size: 15, relativeTo: .body))
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
                        Image(systemName: SFSymbols.arrowLeft)
                            .imageScale(.medium)
                            .foregroundColor(.black)
                    },
                trailing:
                    Button(action: { self.showShareAlert = true }) {
                        Image(systemName: SFSymbols.squareArrowUp)
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
