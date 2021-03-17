//
//  DetailViewTest.swift
//  FoodManChu
//
//  Created by William Yeung on 3/15/21.
//

import SwiftUI

struct DetailViewTest: View {
    let screenSize = UIScreen.main.bounds
    var recipeManager = RecipeManager()
    
    var body: some View {
        ScrollView {
            VStack {
                Image("food")
                    .resizable()
                    .frame(width: screenSize.width * 0.45, height: screenSize.width * 0.45)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .shadow(color: Color.black, radius: 10)
                    )
                    
                Text("Cheesburger")
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                    .lineLimit(nil)
                    .font(.custom("Comfortaa-Bold", size: 26, relativeTo: .body))
                
                HStack {
                    Spacer()
                    
                    Text("Meat")
                        .font(.custom("Comfortaa-Medium", size: 16, relativeTo: .body))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .cornerRadius(8)

                    Divider()
                        .background(Color.black)
                        .frame(width: 1, height: 15)
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("16h 2m")
                            .font(.custom("Comfortaa-Medium", size: 16, relativeTo: .body))
                    }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color.orange)
                        .cornerRadius(8)
                    
                    Spacer()
                }
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Divider()
                    .background(Color.black.opacity(0.2))
                
                // Description
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.custom("Comfortaa-Medium", size: 20, relativeTo: .body))
                        .underline()
                        .padding(.bottom, 1)
                    
                    Text("slkfj 930 2394 3u402o s fisf weiur owieru iowuer 9023490 023 49023480 340 90234093 49 23490923 493 40923hhjhkhj888798789iuioiu")
                        .font(.custom("comfortaa-light", size: 16, relativeTo: .body))
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red)
                    .padding(.top, 10)
                    .padding(.bottom, 50)
//                    .background(Color.green)
                
                CustomSegmentedPickerWithMenu(recipeManager: self.recipeManager)
                    .background(Color.blue)
                
                Spacer()
            }
                .padding(.vertical, 40)
                .padding(.horizontal, 20)
        }
    }
}


struct DetailViewTest_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewTest()
    }
}
