//
//  CustomNavBarWithSearch.swift
//  FoodManChu
//
//  Created by William Yeung on 3/2/21.
//

import SwiftUI

struct NavBarWithSearch: UIViewControllerRepresentable {
    var rootView: AnyView
    var title: String
    var prefersLargeTitle: Bool
    var placeholder: String
    var onSearch: (String) -> Void
    var onCancel: () -> Void
    
    init(rootView: AnyView, title: String, prefersLargeTitle: Bool, placeholder: String, onSearch: @escaping (String) -> Void, onCancel: @escaping () -> Void) {
        self.rootView = rootView
        self.title = title
        self.prefersLargeTitle = prefersLargeTitle
        self.placeholder = placeholder
        self.onSearch = onSearch
        self.onCancel = onCancel
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let hostController = UIHostingController(rootView: rootView)
        let navController = UINavigationController(rootViewController: hostController)
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = self.placeholder
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = context.coordinator
        
        navController.navigationBar.topItem?.title = self.title
        navController.navigationBar.prefersLargeTitles = self.prefersLargeTitle
        navController.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
        navController.navigationBar.topItem?.searchController = searchController
        navController.navigationBar.topItem?.hidesSearchBarWhenScrolling = true
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        uiViewController.navigationBar.topItem?.title = title
        uiViewController.navigationBar.topItem?.searchController?.searchBar.placeholder = placeholder
        uiViewController.navigationBar.prefersLargeTitles = prefersLargeTitle
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: NavBarWithSearch
        
        init(parent: NavBarWithSearch) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.parent.onSearch(searchText)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.parent.onCancel()
        }
    }
}
