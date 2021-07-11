//
//  ActiveTextField.swift
//  FoodBook
//
//  Created by William Yeung on 7/8/21.
//

import SwiftUI

struct ActiveTextField: UIViewRepresentable {
    // MARK: - Properties
    @Binding var text: String
    var isFirstResponder: Bool = false
    var placeholder: String

    // MARK: - Helpers
    func makeUIView(context: UIViewRepresentableContext<ActiveTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: FBFont.medium, size: 14)!)
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<ActiveTextField>) {
        if isFirstResponder && !context.coordinator.hasBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.hasBecomeFirstResponder = true
        }
    }
    
    func makeCoordinator() -> ActiveTextField.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: ActiveTextField
        var hasBecomeFirstResponder = false

        init(parent: ActiveTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
