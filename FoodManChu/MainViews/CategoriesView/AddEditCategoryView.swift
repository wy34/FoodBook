//
//  AddEditCategoryView.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct AddEditCategoryView: View {
    // MARK: - Properties
    var category: Category?
    
    @ObservedObject var categoryManager: CategoryManager
    
    @State private var isPhotoLibraryOpen = false
    @State private var isCameraOpen = false

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Name").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                        TextField("Category", text: self.$categoryManager.categoryName)
                            .padding(.top, -25)
                    }
                        .padding(.top, 25)
                    
                    Section(header: Text("Image (Optional)").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                        Button(action: { self.isPhotoLibraryOpen = true }) {
                            Text("Photo Library")
                                .foregroundColor(.mainGreen)
                        }
                        
                        Button(action: { self.isCameraOpen = true }) {
                            Text("Camera")
                                .foregroundColor(.mainGreen)
                        }
                        
                        Image(uiImage: self.categoryManager.categoryImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                }
                .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
                    .navigationBarTitle(self.categoryManager.isShowingEditingView ? "Edit \(self.category!.name!)" : "New Category", displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: SFSymbols.xmark)
                                .imageScale(.medium)
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
                        .font(.custom(FBFont.bold, size: 22, relativeTo: .body))
                        .foregroundColor(self.categoryManager.categoryName.isEmpty ? Color(.systemGray2) :.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(self.categoryManager.categoryName.isEmpty ? Color.gray : Color.mainGreen)
                        .cornerRadius(20)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 10)
                }
                    .padding(.top, 15)
                    .disabled(self.categoryManager.categoryName.isEmpty ? true : false)
            }
        }
            .preferredColorScheme(.light)
            .sheet(isPresented: self.isPhotoLibraryOpen ? $isPhotoLibraryOpen : $isCameraOpen) {
                ImagePicker(sourceType: self.isPhotoLibraryOpen ? .photoLibrary : .camera, selectedImage: self.$categoryManager.categoryImage, isImagePickerOpen: self.isPhotoLibraryOpen ? $isPhotoLibraryOpen : $isCameraOpen)
            }
    }
    
    private func saveNewCategory() {
        let category = Category(context: moc)
        category.name = self.categoryManager.categoryName
        category.thumbnail = self.categoryManager.categoryImage.pngData()
        PersistenceController.shared.save()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func updateCategory(category: Category) {
        category.name = self.categoryManager.categoryName
        category.thumbnail = self.categoryManager.categoryImage.pngData()
        PersistenceController.shared.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}
