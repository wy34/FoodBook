//
//  Discover.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI
import Network

// MARK: - Discover
struct Discover: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ZStack() {
                    VStack {
                        Text("Currently empty. Share a recipe or try refreshing!")
                            .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                            .multilineTextAlignment(.center)
                            .foregroundColor(cloudKitManager.recipes.isEmpty && !cloudKitManager.isLoading && cloudKitManager.isConnectedToInternet ? .black : .clear)
                            .frame(width: UIScreen.main.bounds.width * 0.8)

                        if cloudKitManager.isLoading && cloudKitManager.isConnectedToInternet {
                            VStack {
                                LoadingSpinner()
                                Text("Loading...")
                                    .foregroundColor(.white)
                                    .font(.custom("Comfortaa-Medium", size: 14, relativeTo: .body))
                            }
                                .frame(width: 75, height: 75)
                                .padding()
                                .background(Color(.systemGray2))
                                .cornerRadius(10)
                        }
                        
                        if !cloudKitManager.isConnectedToInternet {
                            Text("Please enable internet connection in order to view shared recipes.")
                                .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
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
                .navigationBarTitle("Discover")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.cloudKitManager.fetchRecipeRecords()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.medium)
                    }
                )
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func sortedRecipes() -> [RecipeRecord] {
        var recipes = [RecipeRecord]()
        
        recipes = self.cloudKitManager.recipes.sorted(by: { (left, right) -> Bool in
            left.creationDate! > right.creationDate!
        })
        
        return recipes
    }
}


// MARK: - DiscoverCell
struct DiscoverCell: View {
    var recipeRecord: RecipeRecord
    
    var formattedTimeLabel: Text {
        if recipeRecord.timeHour == 0.0 {
            return Text("\(recipeRecord.timeMinute, specifier: "%.0f")m")
        } else {
            return Text("\(recipeRecord.timeHour, specifier: "%.0f")h \(recipeRecord.timeMinute, specifier: "%.0f")m")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(uiImage: recipeRecord.recipeImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(recipeRecord.recipeName)
                    .lineLimit(nil)
                    .font(.custom("Comfortaa-Bold", size: 22, relativeTo: .body))
                    .foregroundColor(.black)
                    .padding(.top, 12)
                
                HStack {
                    Text(recipeRecord.recipeCategory)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .cornerRadius(8)

                    Divider()
                        .background(Color.black)
                        .frame(width: 1, height: 15)
                    
                    HStack {
                        Image(systemName: "clock")
                        formattedTimeLabel
                    }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.orange)
                        .cornerRadius(8)
                    
                    Spacer()
                }
                    .foregroundColor(.white)
                    .font(.custom("Comfortaa-Medium", size: 14, relativeTo: .body))
                    .padding(.top, 5)
                
                Text(recipeRecord.recipeDescription)
                    .font(.custom("Comfortaa-Medium", size: 16, relativeTo: .body))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .foregroundColor(Color(.darkGray))
                    .padding(.bottom, 8)
                    .padding(.top, 8)
            }
                .padding(.horizontal, 8)
        }
    }
}
