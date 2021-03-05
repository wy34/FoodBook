//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 2/27/21.
//

import SwiftUI

// MARK: - CategoriesView
struct CategoriesView2: View {
    @State private var addingNewCategory = false
    @EnvironmentObject var modalManager: ModalManager
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                CategoryGrid()
                
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
            .fullScreenCover(isPresented: self.$addingNewCategory) {
                NewCategoryView()
            }
    }
}

// MARK: - Previews
struct CategoriesView2_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView2()
            .environmentObject(ModalManager())
            .preferredColorScheme(.light)
    }
}


// MARK: - CategoryGrid
struct CategoryGrid: View {
    let gridItems = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 200), spacing: 0), count: 1)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SearchBar(placeholder: "Search Categories")
                .padding(.top, 10)
                .padding(.horizontal, 5)
            
            LazyVGrid(columns: gridItems, alignment: .center, spacing: 20, content: {
                ForEach(0..<15) { i in
                    NavigationLink(destination: RecipeView()) {
                        CategoryCell()
                    }
                }
            })
                .padding(.top, 15)
                .padding(.bottom, 15)
        }
            .navigationBarTitle("Categories")
    }
}


// MARK: - CategoryCell
struct CategoryCell: View {
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        Image("food2")
            .resizable()
            .scaledToFill()
            .frame(width: screenSize.width - 40, height: 200)
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.5), radius: 8, x: 10, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.black.opacity(0.2))
                    .overlay(
                        Text("Vegetarian")
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .font(.custom("TypoRoundBoldDemo", size: 45, relativeTo: .body))
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .padding(.horizontal, 20)
                            .minimumScaleFactor(0.5)
                    )
            )
    }
}

// MARK: - NewCategoryView
struct NewCategoryView: View {
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @State private var category = ""
    @State private var isImagePickerOpen = false
    @State private var selectedImage = Image("food")
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Form {
                    Section(header: Text("Name").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        TextField("Category", text: $category)
                            .padding(.top, -25)
                    }
                        .padding(.top, 25)
                    
                    Section(header: Text("Select an image").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        Button(action: { self.isImagePickerOpen = true }) {
                            Text("Open Image Picker")
                                .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        }
                        
                        selectedImage
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                }
                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                    .navigationBarTitle("New Category", displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                    )
                
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                     Text("Save")
                        .font(.custom("TypoRoundBoldDemo", size: 24, relativeTo: .body))
                        .foregroundColor(self.category.isEmpty ? Color(.systemGray2) :.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(self.category.isEmpty ? Color.gray : Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .cornerRadius(20)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 10)
                }
                    .padding(.top, 15)
                    .disabled(self.category.isEmpty ? true : false)
            }
        }
            .sheet(isPresented: $isImagePickerOpen) {
                ImagePicker(selectedImage: $selectedImage, isImagePickerOpen: $isImagePickerOpen)
            }
    }
}


struct NewCategoryView_previews: PreviewProvider {
    static var previews: some View {
        NewCategoryView().preferredColorScheme(.dark)
    }
}


// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Image
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
            self.parent.selectedImage = Image(uiImage: image)
            self.parent.isImagePickerOpen.toggle()
        }
    }
}

