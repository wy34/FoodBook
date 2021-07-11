//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct RootView: View {
    // MARK: - Properties
    @State private var selectedTab = 0
    @State private var scale = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                CategoriesView()
                    .tabItem {
                        Image(systemName: SFSymbols.hammer)
                        Text("Builder")
                    }
                        .tag(0)
                RecipesBookView()
                    .tabItem {
                        Image(systemName: SFSymbols.book)
                        Text("Book")
                    }
                        .tag(1)
                DiscoverView()
                    .tabItem {
                        Image(systemName: SFSymbols.globe)
                        Text("Discover")
                    }
                        .tag(2)
        }
                .accentColor(.mainGreen)
                .overlay(
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                        .opacity(scale ? 0.25 : 0)
                )
            
            if selectedTab == 2 {
                VStack(spacing: 8) {
                    Text("Hello There!")
                        .font(.custom(FBFont.bold, size: 24, relativeTo: .body))
                        .foregroundColor(.mainGreen)
                    Text("This is where you can see all of your shared recipes, as well as anything other users of the app have shared.")
                        .font(.custom(FBFont.medium, size: 16, relativeTo: .body))
                        .foregroundColor(.black)
                }
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.2)
                    .padding()
                    .padding(.horizontal)
                    .background(Color(#colorLiteral(red: 0.9011624455, green: 0.894621551, blue: 0.9192818403, alpha: 1)))
                    .cornerRadius(15)
                    .overlay(
                        Button(action: { withAnimation { self.scale = false; DiscoverAlertManager.shared.setAsOldUser() } }) {
                            Image(systemName: SFSymbols.xmark)
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

// MARK: - Previews
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(ModalManager())
    }
}

