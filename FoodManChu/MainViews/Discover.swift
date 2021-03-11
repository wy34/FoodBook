//
//  Discover.swift
//  FoodManChu
//
//  Created by William Yeung on 3/10/21.
//

import SwiftUI

struct Discover: View {    
    var body: some View {
        NavigationView {
            ScrollView() {
                VStack(spacing: 20) {
                    ForEach(0..<1) { i in
                        NavigationLink(destination: DiscoverMoreView()) {
                            VStack {
                                DiscoverCell()
                                
                                if i != 9 {
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
                .navigationBarTitle("Discover")
                .navigationBarItems(trailing:
                    Button(action: {  }) {
                        Image(systemName: "arrow.clockwise")
                    }
                )
        }
    }
}

struct Discover_Previews: PreviewProvider {
    static var previews: some View {
        Discover()
    }
}


struct DiscoverCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("food2")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            Text("General Tso's Chicken")
                .lineLimit(nil)
                .font(.custom("TypoRoundBoldDemo", size: 24, relativeTo: .body))
                .padding(.top, 12)
                .foregroundColor(.black)
            HStack {
                Text("Meat")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                    .cornerRadius(8)

                Divider()
                    .background(Color.black)
                    .frame(width: 1, height: 15)
                
                HStack {
                    Image(systemName: "clock")
                    Text("1h 30m")
                }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
                .foregroundColor(.white)
                .font(.custom("TypoRoundRegularDemo", size: 18, relativeTo: .body))
                .padding(.top, 12)
            
            Text("3 ijrioj02 394 29304 ksjf i3093 sifjisjfoisjf 342349 sfjj  sjf e isjfi sdifsjd fiosjfsif osf jieojwerier wierjoier 23i iw eirieuriwer ie riwer sdkjf sdkfjlsdjf eirwoer iwer iewro weir02409 394 203")
                .lineLimit(nil)
                .foregroundColor(Color(.darkGray))
                .padding(.bottom, 8)
                .padding(.top, 15)
        }
    }
}
