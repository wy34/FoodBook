//
//  Discover.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct Discover: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                ZStack() {
                    VStack {
                        Text("Currently empty. Share a recipe or try refreshing!")
                            .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                            .multilineTextAlignment(.center)
                            .foregroundColor(cloudKitManager.recipes.isEmpty && !cloudKitManager.isLoading ? .black : .clear)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                        
                        
                        if cloudKitManager.isLoading {
                            VStack {
                                LoadingSpinner()
                                Text("Loading...")
                                    .foregroundColor(.white)
                                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                            }
                                .frame(width: 75, height: 75)
                                .padding()
                                .background(Color(.systemGray2))
                                .cornerRadius(10)
                        }
                    }
                        .padding(.top, 75)

                    
                    VStack(spacing: 20) {
                        ForEach(0..<cloudKitManager.recipes.count, id: \.self) { i in
                            NavigationLink(destination: DiscoverMoreView(recipeRecord: cloudKitManager.recipes[i])) {
                                VStack {
                                    DiscoverCell(recipeRecord: cloudKitManager.recipes[i])
                                    
                                    if i != cloudKitManager.recipes.count - 1 {
                                        Divider()
                                            .background(Color.black)
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
                        self.cloudKitManager.recipes.removeAll()
                        self.cloudKitManager.fetchRecipeRecords()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                )
        }
    }
}


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
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            Text(recipeRecord.recipeName)
                .lineLimit(nil)
                .font(.custom("TypoRoundBoldDemo", size: 24, relativeTo: .body))
                .padding(.top, 12)
                .foregroundColor(.black)
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
            }
                .foregroundColor(.white)
                .font(.custom("TypoRoundRegularDemo", size: 18, relativeTo: .body))
                .padding(.top, 12)
            
            Text(recipeRecord.recipeDescription)
                .frame(maxWidth: .infinity)
                .lineLimit(nil)
                .foregroundColor(Color(.darkGray))
                .padding(.bottom, 8)
                .padding(.top, 15)
        }
//        .padding(.horizontal)
    }
}


struct LoadingSpinner: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
}
