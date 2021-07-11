//
//  Discover.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI
import Network

struct DiscoverView: View {
    // MARK: - Properties
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(showsIndicators: false) {
                    ZStack() {
                        VStack {
                            Text("Currently empty. Share a recipe or try refreshing!")
                                .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                                .multilineTextAlignment(.center)
                                .foregroundColor(cloudKitManager.recipes.isEmpty && !cloudKitManager.isLoading && cloudKitManager.isConnectedToInternet ? .black : .clear)
                                .frame(width: UIScreen.main.bounds.width * 0.8)

                            if cloudKitManager.isLoading && cloudKitManager.isConnectedToInternet {
                                VStack {
                                    LoadingSpinner()
                                    Text("Loading...")
                                        .foregroundColor(.white)
                                        .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
                                }
                                    .frame(width: 75, height: 75)
                                    .padding()
                                    .background(Color(.systemGray2))
                                    .cornerRadius(10)
                            }
                            
                            if !cloudKitManager.isConnectedToInternet {
                                Text("Please enable internet connection in order to view shared recipes.")
                                    .font(.custom(FBFont.bold, size: 14, relativeTo: .body))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .frame(width: UIScreen.main.bounds.width * 0.8)
                            }
                        }
                            .padding(.top, 75)

                        
                        VStack(spacing: 20) {
                            if cloudKitManager.isConnectedToInternet {
                                ForEach(0..<self.sortedRecipes().count, id: \.self) { i in
                                    NavigationLink(destination: DiscoverMoreView(recipeRecord: sortedRecipes()[i])) {
                                        VStack {
                                            DiscoverCell(recipeRecord: sortedRecipes()[i])

                                            if i != cloudKitManager.recipes.count - 1 {
                                                Divider()
                                                    .background(Color.black)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 20)
                    }
                }
            }
                .navigationBarTitle("Discover")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.cloudKitManager.fetchRecipeRecords()
                    }) {
                        Image(systemName: SFSymbols.arrowClockwise)
                            .imageScale(.medium)
                    }
                )
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Helpers
    private func sortedRecipes() -> [RecipeRecord] {
        var recipes = [RecipeRecord]()
        
        recipes = self.cloudKitManager.recipes.sorted(by: { (left, right) -> Bool in
            left.creationDate! > right.creationDate!
        })
        
        return recipes
    }
}
