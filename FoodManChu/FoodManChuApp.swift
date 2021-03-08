//
//  FoodManChuApp.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

@main
struct FoodManChuApp: App {
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 18)!)
        ]
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundBoldDemo", size: 30)!)
        ]
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .black
        
        UISlider.appearance().tintColor = #colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @StateObject var persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase // use with .onChange to save whenever app is going to background
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // used for creating objects, etc
                .environmentObject(persistenceController) // to save nsmanagedobjects
                .environmentObject(ModalManager())
                .preferredColorScheme(.light)
                .onAppear() {
                    persistenceController.createDefaultCategories()
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                }
        }
            .onChange(of: scenePhase) { (_) in
                persistenceController.save()
            }
    }
}
