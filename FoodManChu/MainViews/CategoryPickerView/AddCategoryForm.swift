//
//  AddCategoryForm.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct AddCategoryForm: View {
    // MARK: - Properties
    @ObservedObject var categoryManager: CategoryManager
    @Binding var isPhotoLibraryOpen: Bool
    @Binding var isCameraOpen: Bool
    @Binding var tabSelection: Int
    @Binding var tappedCategory: Category?
    
    // MARK: - Body
    var body: some View {
        let textFieldBinding = Binding<String>(
            get: { return self.categoryManager.categoryName },
            set: { self.categoryManager.categoryName = $0; tappedCategory = nil }
        )
        
        VStack(spacing: 0) {
            Form {
                Section(header: Text("Name").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                    TextField("Category", text: textFieldBinding)
                        .padding(.top, -20)
                }
                    .padding(.top, 25)
                
                Section(header: Text("Image (Optional)").font(.custom(FBFont.medium, size: 10, relativeTo: .body))) {
                    Button(action: { self.isPhotoLibraryOpen = true }) {
                        Text("Photo Library")
                            .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                    }
                    
                    Button(action: { self.isCameraOpen = true }) {
                        Text("Camera")
                            .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                    }
                    
                    Image(uiImage: self.categoryManager.categoryImage)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(10)
                        .padding(.vertical)
                }
            }
                .font(.custom(FBFont.medium, size: 14, relativeTo: .body))
            
            Spacer(minLength: 75)
        }
            .preferredColorScheme(.light)
            .sheet(isPresented: self.isPhotoLibraryOpen ? $isPhotoLibraryOpen : $isCameraOpen) {
                ImagePicker(sourceType: self.isPhotoLibraryOpen ? .photoLibrary : .camera, selectedImage: self.$categoryManager.categoryImage, isImagePickerOpen: self.isPhotoLibraryOpen ? $isPhotoLibraryOpen : $isCameraOpen)
            }
    }
}
