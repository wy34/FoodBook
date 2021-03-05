//
//  RecipeDetailView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/1/21.
//

import SwiftUI

// MARK: - RecipeDetailView
struct RecipeDetailView: View {
    let screenSize = UIScreen.main.bounds
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack {
                Image("food2")
                    .resizable()
                    .frame(width: screenSize.width * 0.45, height: screenSize.width * 0.45)
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .shadow(color: Color.black, radius: 10)
                    )
                    
                 Text("Beef with Broccoli")
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                    .lineLimit(nil)
                    .font(.custom("TypoRoundBoldDemo", size: 28, relativeTo: .body))
                
                HStack {
                    Text("25 min")
                        .font(.custom("TypoRoundLightDemo", size: 18, relativeTo: .body))
                        .cornerRadius(5)
                    Divider()
                        .background(Color.black)
                        .frame(width: 1, height: 15)
                    Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1))
                        .frame(width: 45, height: 30)
                        .cornerRadius(5)
                }
                    .padding(.bottom, 15)
                
                Divider()
                
                // Description
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.custom("TypoRoundRegularDemo", size: 22, relativeTo: .body))
                        .underline()
                        .padding(.bottom, 1)
                    
                    Text("lsaf slkjdflksj;fdk ksdfj lkjsdf sjd ljlsjdlf kjf sldfl dksjflsdjf ksdjfljsdf ldfjj skdjfls ksdjfljsdf ldfjj skdjfls ksdjfljsdf ldfjj skdjfls ksdjfljsdf ldfjj skdjfls ksdjfljsdf ldfjj skdjfls ksdjfljsdf ldfjj skdjfls")
                        .font(.custom("TypoRoundLightDemo", size: 18, relativeTo: .body))
                        .lineLimit(nil)
                }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                CustomSegmentedPickerWithMenu()
                
                Spacer()
            }
                .padding(.vertical, 30)
                .padding(.horizontal, 15)
        }
    }
}

// MARK: - Preview
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView()
    }
}


