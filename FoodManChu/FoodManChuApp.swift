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
        
        UISegmentedControl.appearance().backgroundColor = #colorLiteral(red: 0.8921687603, green: 0.8965111375, blue: 0.9514744878, alpha: 1)
        UISegmentedControl.appearance().selectedSegmentTintColor = #colorLiteral(red: 0.6970165372, green: 0.7750255466, blue: 0.9293276668, alpha: 1)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundRegularDemo", size: 18)!)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(#colorLiteral(red: 0.7019448876, green: 0.7045716047, blue: 0.7109025717, alpha: 1)), NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundRegularDemo", size: 18)!)], for: .normal)
    }
    
    @StateObject var persistenceController = PersistenceController.shared
    @StateObject var networkManager = NetworkManager()
    @StateObject var cloudKitManager = CloudKitManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // used for creating objects, etc
                .environmentObject(persistenceController) // to save nsmanagedobjects
                .environmentObject(ModalManager())
                .environmentObject(networkManager)
                .environmentObject(cloudKitManager)
                .preferredColorScheme(.light)
                .onAppear() {
                    persistenceController.createDefaultCategories()
                    persistenceController.createDefaultIngredients()
                    networkManager.setupNetworkMonitor()
                    self.cloudKitManager.fetchRecipeRecords() // load it once and all subsequent times will be user manually refreshing
                }
        }
    }
}
