//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

class CategoryManager: ObservableObject {
    @Published var categoryName = ""
    @Published var categoryImage = UIImage(named: "placeholder")!
    
    @Published var isEditOn = false
    @Published var isShowingEditingView = false
    @Published var isShowingDeleteAlert = false
}

// MARK: - CategoriesView
struct CategoriesView: View {
    @State private var addingNewCategory = false
    @EnvironmentObject var modalManager: ModalManager
    @StateObject var categoryManager = CategoryManager()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                CategoryGrid(categoryManager: self.categoryManager)
                
                if !self.categoryManager.isEditOn {
                    Button(action: { self.addingNewCategory = true }) {
                        Image(systemName: "plus")
                            .font(.system(.title))
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width * 0.075, height: UIScreen.main.bounds.width * 0.075)
                            .padding()
                            .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                            .clipShape(Circle())
                    }
                        .padding(.bottom, 20)
                        .padding(.trailing, 20)
                }
            }
                .navigationBarTitle("Categories")
                .navigationBarItems(trailing:
                    Button(action: { self.categoryManager.isEditOn.toggle() }) {
                        Text(self.categoryManager.isEditOn  ? "Done" : "Edit")
                            .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                            .foregroundColor(self.categoryManager.isEditOn  ? .red : .black)
                    })
        }
            .fullScreenCover(isPresented: self.$addingNewCategory) {
                AddEditCategoryView(categoryManager: CategoryManager())
            }
            .onDisappear() {
                self.categoryManager.isEditOn = false
            }
    }
}

// MARK: - Previews
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .environmentObject(ModalManager())
            .preferredColorScheme(.light)
    }
}

// MARK: - CategoryGrid
struct CategoryGrid: View {
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    @StateObject var categoryManager: CategoryManager
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    @EnvironmentObject var persistenceController: PersistenceController

    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SearchBar(placeholder: "Search Categories")
                .padding(.top, 10)
                .padding(.horizontal, 5)
            
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                ForEach(categories, id: \.self) { category in
                    CategoryCell(category: category, isEditing: self.$categoryManager.isEditOn)
                }
            })
                .padding(.top, 15)
                .padding(.bottom, 15)
        }
    }
}

// MARK: - CategoryCell
struct CategoryCell: View {
    var category: Category
    let screenSize = UIScreen.main.bounds
    @Binding var isEditing: Bool
    @StateObject var categoryManager = CategoryManager()
    @EnvironmentObject var persistenceController: PersistenceController
    
    var body: some View {
        if let thumbnailData = category.thumbnail {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .topTrailing) {
                    NavigationLink(destination: RecipeView(category: self.category)) {
                        Image(uiImage: UIImage(data: thumbnailData)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: screenSize.width - 40, height: 200)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 10, y: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black.opacity(self.isEditing ? 0.5 : 0.3))
                                    .overlay(
                                        Text(category.name ?? "")
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.center)
                                            .font(.custom("TypoRoundBoldDemo", size: 45, relativeTo: .body))
                                            .foregroundColor(self.isEditing ? Color(.systemGray2) : .white)
                                            .background(Color.clear)
                                            .padding(.horizontal, 20)
                                            .minimumScaleFactor(0.5)
                                    )
                            )
                    }
                        .disabled(self.isEditing ? true : false)
                    
                    if self.isEditing {
                        Button(action: {
                            self.categoryManager.categoryName = self.category.name ?? ""
                            self.categoryManager.categoryImage = UIImage(data: self.category.thumbnail ?? Data()) ?? UIImage(named: "food")!
                            self.categoryManager.isShowingEditingView = true
                        }) {
                            RoundedButtonView(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner], bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6499315956), cornerRadius: 20)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "pencil.circle")
                                        .font(.title)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                }
                
                if self.isEditing {
                    Button(action: { self.categoryManager.isShowingDeleteAlert = true }) {
                        RoundedButtonView(corners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner], bgColor: #colorLiteral(red: 0.997196734, green: 0.2449620962, blue: 0.2093260586, alpha: 0.7458057316), cornerRadius: 20)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "trash")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
                .animation(.easeIn)
                .fullScreenCover(isPresented: self.$categoryManager.isShowingEditingView) {
                    AddEditCategoryView(category: self.category, categoryManager: categoryManager)
                }
                .alert(isPresented: $categoryManager.isShowingDeleteAlert) {
                    Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this category? Doing so will delete all associated recipes."), primaryButton: .cancel(), secondaryButton: .default(Text("Yes")) {
                            self.delete()
                        }
                    )
                }
        }
    }
    
    func delete() {
        for recipe in category.recipe?.allObjects as! [Recipe] {
            persistenceController.delete(recipe)
        }
        persistenceController.delete(category)
        persistenceController.save()
    }
}

// MARK: - AddEditCategoryView
struct AddEditCategoryView: View {
    var category: Category?
    @ObservedObject var categoryManager: CategoryManager
    
    @State private var isImagePickerOpen = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var persistenceController: PersistenceController

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Name").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        TextField("Category", text: self.$categoryManager.categoryName)
                            .padding(.top, -25)
                    }
                        .padding(.top, 25)
                    
                    Section(header: Text("Image").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        Button(action: { self.isImagePickerOpen = true }) {
                            Text("Open Image Picker")
                                .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        }
                        
                        Image(uiImage: self.categoryManager.categoryImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                }
                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                    .navigationBarTitle(self.categoryManager.isShowingEditingView ? "Edit \(self.category!.name!)" : "New Category", displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                         }
                    )
                
                Button(action: {
                    if self.categoryManager.isShowingEditingView {
                        self.updateCategory(category: self.category!)
                    } else {
                        self.saveNewCategory()
                    }
                }) {
                     Text("Save")
                        .font(.custom("TypoRoundBoldDemo", size: 24, relativeTo: .body))
                        .foregroundColor(self.categoryManager.categoryName.isEmpty ? Color(.systemGray2) :.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(self.categoryManager.categoryName.isEmpty ? Color.gray : Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .cornerRadius(20)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 10)
                }
                    .padding(.top, 15)
                    .disabled(self.categoryManager.categoryName.isEmpty ? true : false)
            }
        }
            .sheet(isPresented: $isImagePickerOpen) {
                ImagePicker(selectedImage: self.$categoryManager.categoryImage, isImagePickerOpen: $isImagePickerOpen)
            }
    }
    
    func saveNewCategory() {
        let category = Category(context: moc)
        category.name = self.categoryManager.categoryName
        category.thumbnail = self.categoryManager.categoryImage.pngData()
        self.persistenceController.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func updateCategory(category: Category) {
        category.name = self.categoryManager.categoryName
        category.thumbnail = self.categoryManager.categoryImage.pngData()
        self.persistenceController.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct NewCategoryView_previews: PreviewProvider {
    static var previews: some View {
        AddEditCategoryView(categoryManager: CategoryManager()).preferredColorScheme(.dark)
    }
}


// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage
    @Binding var isImagePickerOpen: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage else { return }
            self.parent.selectedImage = image
            self.parent.isImagePickerOpen.toggle()
        }
    }
}

