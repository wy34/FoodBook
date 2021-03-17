//
//  NavBarWithSearchBar.swift
//  FoodManChu
//
//  Created by William Yeung on 3/2/21.
//

import SwiftUI

struct NavBarWithSearchBar: View {
    @State private var filteredItems = apps
    
    var body: some View {
        CustomNavigationView(view: AnyView(Home1(filteredItems: $filteredItems)), title: "Kavsoft", placeholder: "Kavsoft", largeTitle: true) { (searchText) in
            if searchText != "" {
                self.filteredItems = apps.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
            } else {
                self.filteredItems = apps
            }
        } onCancel: {
            self.filteredItems = apps
        }
            .edgesIgnoringSafeArea(.top)
    }
}


struct NavBarWithSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBarWithSearchBar()
    }
}

// MARK: - HomeView
struct Home1: View {
    @Binding var filteredItems: [AppItem]
    
    var body: some View {
        ScrollView() {
            VStack(spacing: 15) {
                ForEach(filteredItems) { item in
                    CardView(item: item)
                }
            }
        }
    }
}



// MARK: - Navigation
struct CustomNavigationView: UIViewControllerRepresentable {
    // pass in whatever view requires a searchbar
    var view: AnyView
    var onSearch: (String) -> Void
    var onCancel: () -> Void
    
    var largeTitle: Bool
    var title: String
    var placeholder: String
    
    init(view: AnyView, title: String, placeholder: String, largeTitle: Bool, onSearch: @escaping (String) -> Void, onCancel: @escaping () -> Void) {
        self.view = view
        self.onSearch = onSearch
        self.onCancel = onCancel
        self.largeTitle = largeTitle
        self.title = title
        self.placeholder = placeholder
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let childView = UIHostingController(rootView: view)
        let controller = UINavigationController(rootViewController: childView)
        controller.navigationBar.topItem?.title = title
        controller.navigationBar.prefersLargeTitles = largeTitle
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = placeholder
        searchController.obscuresBackgroundDuringPresentation = false
    
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController
        
        searchController.searchBar.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
//        uiViewController.navigationBar.topItem?.title = title
//        uiViewController.navigationBar.topItem?.searchController?.searchBar.placeholder = placeholder
//        uiViewController.navigationBar.prefersLargeTitles = largeTitle
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: CustomNavigationView
        
        init(parent: CustomNavigationView) {
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




// MARK: - Card View
struct CardView: View {
    var item: AppItem
    @State private var show = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(item.name)
                .resizable()
                .frame(width: 65, height: 65)
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.name)
                            .font(.title2)
                        
                        Text(item.source)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer(minLength: 10)
                    
                    VStack {
                        Button(action: { self.show.toggle() }) {
                            Text(self.show ? "Open" : "GET")
                                .fontWeight(.heavy)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.primary.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        
                        Text("In App Purchase")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
            }
        }
        .padding(.horizontal)
    }
}





// MARK: - Data
struct AppItem: Identifiable {
    var id = UUID().uuidString
    var name: String
    var source = "Apple"
}


var apps = [
    AppItem(name: "app store"),
    AppItem(name: "itunes"),
    AppItem(name: "movies"),
    AppItem(name: "notes"),
    AppItem(name: "gmail"),
    AppItem(name: "youtube"),
    AppItem(name: "messages"),
    AppItem(name: "twitter"),
    AppItem(name: "facebook"),
    AppItem(name: "instagram"),
    AppItem(name: "clubhouse"),
    AppItem(name: "xcode"),
    AppItem(name: "photos"),
    AppItem(name: "robinhood"),
    AppItem(name: "safari"),
]
