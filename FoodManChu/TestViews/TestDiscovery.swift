//
//  TestDiscovery.swift
//  FoodManChu
//
//  Created by William Yeung on 3/13/21.
//

import SwiftUI

struct DiscoveryTest: View {
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(spacing: 20) {
                        ForEach(0..<10, id: \.self) { i in
                            NavigationLink(destination: TestDiscovery()) {
                                VStack {
                                    TestDiscovery()
                                    
                                    if i != 10 - 1 {
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
        }
    }
}

struct DiscoveryTest_previews: PreviewProvider {
    static var previews: some View {
        DiscoveryTest()
    }
}

struct TestDiscovery: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("food")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            Text("Cheeseburger")
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
                    Text("16h 35m")
                }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
                .foregroundColor(.white)
                .font(.custom("TypoRoundRegularDemo", size: 18, relativeTo: .body))
                .padding(.top, 12)
            
            Text("alksdfjlksdf sldjflsdjf ksljdfl sdkf lksdf skdfj lsdjfl sfjweiuriwer iwer wieru woeur worweiorweirpweriwer iwerowe riw e928348209 82u3409 2340 02 34")
                .frame(maxWidth: .infinity)
                .lineLimit(nil)
                .foregroundColor(Color(.darkGray))
                .padding(.bottom, 8)
                .padding(.top, 15)
        }
    }
}

struct TestDiscovery_Previews: PreviewProvider {
    static var previews: some View {
        TestDiscovery()
    }
}
