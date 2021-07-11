//
//  ImagePicker.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    // MARK: - Properties
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage
    @Binding var isImagePickerOpen: Bool
    
    // MARK: - Helpers
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = sourceType
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

