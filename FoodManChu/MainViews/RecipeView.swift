//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

// MARK: - RecipeView
struct RecipeView: View {
    // 2 columns, this spacing is between columns
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200), spacing: 15), count: 2)
    let screenSize = UIScreen.main.bounds
    
    @State private var isEditing = false
    
    @EnvironmentObject var modalManager: ModalManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            RecipeGrid(isEditing: $isEditing)

            if modalManager.isRecipeDetailViewShowing {
                CustomModalView(content: RecipeDetailView())
                    .animation(Animation.easeInOut(duration: 0.4))
            }
        }
        .onDisappear() {
            self.modalManager.isRecipeDetailViewShowing = false
            self.isEditing = false
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
            .environmentObject(ModalManager())
    }
}


// MARK: - RecipeGrid
struct RecipeGrid: View {
    // 2 columns, this spacing is between columns
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 50, maximum: 200), spacing: 15), count: 2)
    let screenSize = UIScreen.main.bounds
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modalManager: ModalManager
    @Binding var isEditing: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                ScrollView(showsIndicators: false) {
                    SearchBar(placeholder: "Search Recipes")
                        .padding(.top, 15)
                        .padding(.horizontal, 5)
                    
                    // this spacing is between rows
                    LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                        ForEach(0..<11) { i in
                            RecipeCell(isEditing: $isEditing)
                        }
                    })
                        .padding(15)
                }
                    .navigationBarTitle("Meat", displayMode: .inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: // have to put in here otherwise won't show in navbar
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "arrow.left")
                                .imageScale(.large)
                                .foregroundColor(.black)
                        }, trailing:
                            Button(action: { self.isEditing.toggle(); self.modalManager.isRecipeDetailViewShowing = false }) {
                            Text(self.isEditing ? "Cancel" : "Edit")
                                .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                                .foregroundColor(self.isEditing ? .red : .black)
                        }
                    )
            }
            
            if !self.isEditing {
                Button(action: {  }) {
                    Image(systemName: "plus")
                        .font(.system(.title))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.075, height: UIScreen.main.bounds.width * 0.075)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .clipShape(Circle())
                }
                    .padding(.bottom, 20)
                    .padding(.trailing, 20)
            }
        }
    }
}

// MARK: - RecipeCell
struct RecipeCell: View {
    let screenSize = UIScreen.main.bounds
    
    @Binding var isEditing: Bool
    @EnvironmentObject var modalManager: ModalManager

    var body: some View {
        VStack {
            ZStack {
                Button(action: { self.modalManager.isRecipeDetailViewShowing = true }) {
                    Image("food2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: screenSize.width / 2 - 35, height: screenSize.height / 4)
                        .cornerRadius(30)
                }
                
                if self.isEditing {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.black.opacity(0.35))
                        .frame(width: screenSize.width / 2 - 35, height: screenSize.height / 4)
                        .overlay(
                            Button(action: {}) {
                                Image(systemName: "pencil.circle")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                                    .padding(30)
                            }
                        )
                } 
            }
                .animation(.easeInOut)
                
            Text("Beef with Broccoli")
                .multilineTextAlignment(.center)
                .font(.custom("TypoRoundRegularDemo", size: 18, relativeTo: .body))
                .frame(width: screenSize.width / 2 - 35)
                .lineLimit(nil)
                .padding(.top, 3)
        }
    }
}

struct RecipeCell_previews: PreviewProvider {
    static var previews: some View {
        RecipeCell(isEditing: .constant(false))
    }
}
