//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab = 0
    @State private var scale = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
            CategoriesView()
                .tabItem {
                    Image(systemName: "hammer")
                    Text("Builder")
                        
                }
                    .tag(0)
            RecipesBookView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Book")
                }
                    .tag(1)
            Discover()
                .tabItem {
                    Image(systemName: "globe")
                    Text("Discover")
                }
                    .tag(2)
        }
                .accentColor(Color(#colorLiteral(red: 0.4468465447, green: 0.6117238402, blue: 0.4210793078, alpha: 1)))
                .overlay(
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                        .opacity(scale ? 0.25 : 0)
                )
            
            if selectedTab == 2 {
                VStack(spacing: 12) {
                    Text("Hello There!")
                        .font(.custom("Comfortaa-Bold", size: 26, relativeTo: .body))
                        .foregroundColor(Color(#colorLiteral(red: 0.4468465447, green: 0.6117238402, blue: 0.4210793078, alpha: 1)))
                    Text("This is where you can see all of your shared recipes, as well as anything other users of the app have shared.")
                        .font(.custom("Comfortaa-Medium", size: 16, relativeTo: .body))
                        .foregroundColor(.black)
                }
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.18)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(#colorLiteral(red: 0.9011624455, green: 0.894621551, blue: 0.9192818403, alpha: 1)))
                    .cornerRadius(15)
                    .overlay(
                        Button(action: { withAnimation { self.scale = false; DiscoverAlertManager.shared.setAsOldUser() } }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedButtonView(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner], bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5), cornerRadius: 15)
                                )
                        }
                        , alignment: .topTrailing
                    )
                    .scaleEffect(scale ? 1 : 0)
                    .animation(Animation.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: scale)
                    .onAppear() {
                        if DiscoverAlertManager.shared.isFirstTimeViewingDiscoverPage {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                self.scale = true
                            }
                        }
                    }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModalManager())
    }
}

