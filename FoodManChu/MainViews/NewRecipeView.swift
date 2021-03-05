//
//  NewRecipeView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/4/21.
//

import SwiftUI


enum Steps: String {
    case Ingredient
    case Direction
}

// MARK: - NewRecipeManager
class NewRecipeManager: ObservableObject {
    @Published var selectedImage = Image("food")
    @Published var isImagePickerOpen = false
    @Published var name = ""
    @Published var description = ""
    @Published var hours = 0.0
    @Published var minutes = 0.0
}


// MARK: - NewRecipeView
struct NewRecipeView: View {
    init() {
        UISlider.appearance().tintColor = #colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    @StateObject var newRecipeManager = NewRecipeManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Details").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        TextField("Name", text: self.$newRecipeManager.name)
                        ZStack(alignment: .leading) {
                            Text("Description")
                                .foregroundColor(!self.newRecipeManager.description.isEmpty ? .clear : Color(#colorLiteral(red: 0.7848425508, green: 0.7855817676, blue: 0.7926406264, alpha: 1)))
                            TextEditor(text: self.$newRecipeManager.description)
                                .padding(.leading, -5)
                        }
                    }
                    
                    Section(header: Text("Select an image").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        Button(action: { self.newRecipeManager.isImagePickerOpen = true }) {
                            Text("Open Image Picker")
                                .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        }

                        self.newRecipeManager.selectedImage
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                    
                    
                    Section(header: Text("Time").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        HStack {
                            Slider(value: self.$newRecipeManager.hours, in: 0...23, step: 1)
                            Text("\(self.newRecipeManager.hours, specifier: "%.0f") h")
                        }

                        HStack {
                            Slider(value: self.$newRecipeManager.minutes, in: 0...59, step: 1)
                            Text("\(self.newRecipeManager.minutes, specifier: "%.0f") m")
                        }
                    }
                    
                    Section(header: Text("Other").font(.custom("TypoRoundRegularDemo", size: 12, relativeTo: .body))) {
                        NavigationLink(destination: AddingStepsView(stepsType: .Ingredient)) {
                            Text("Ingredients")
                        }
                        NavigationLink(destination: AddingStepsView(stepsType: .Direction)) {
                            Text("Directions")
                        }
                    }

                }
                    .font(.custom("TypoRoundRegularDemo", size: 16, relativeTo: .body))
                    .navigationBarTitle(Text("New Recipe"), displayMode: .inline)
                    .navigationBarItems(leading:
                        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .imageScale(.large)
                                .foregroundColor(.primary)
                        }
                    )
                    .sheet(isPresented: self.$newRecipeManager.isImagePickerOpen) {
                        ImagePicker(selectedImage: self.$newRecipeManager.selectedImage, isImagePickerOpen: self.$newRecipeManager.isImagePickerOpen)
                    }
                
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                     Text("Save")
                        .font(.custom("TypoRoundBoldDemo", size: 24, relativeTo: .body))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .cornerRadius(20)
                        .padding([.horizontal], 20)
                        .padding(.bottom, 10)
                }
                .padding(.top, 15)
            }
        }
    }
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView()
    }
}


// MARK: - AddingStepsView
struct AddingStepsView: View {
    var stepsType: Steps
    var testData = ["Cheese"]

    @State private var showingPopup = false
    
    var body: some View {
        ZStack {
            Form {
                Button(action: { self.showingPopup = true }) {
                    Label("Add New \(stepsType.rawValue)", systemImage: "plus")
                        .foregroundColor(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                        .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                }
                
                ForEach(testData, id: \.self) { data in
                    HStack {
                        Text(data)
                            .font(.custom("TypoRoundLightDemo", size: 16, relativeTo: .body))
                        Spacer()
                        Text("2 cups")
                            .font(.custom("TypoRoundLightDemo", size: 12, relativeTo: .body))
                    }
                }
            }
            
            if self.showingPopup {
                NewStepPopupView(stepsType: stepsType, showingPopup: $showingPopup)
            }
        }
    }
}

struct AddingStepsView_Previews: PreviewProvider {
    static var previews: some View {
        AddingStepsView(stepsType: .Ingredient)
    }
}


// MARK: - PopupView
struct NewStepPopupView: View {
    var stepsType: Steps
    @Binding var showingPopup: Bool
    
    @State private var ingredientName = ""
    @State private var ingredientAmount = ""
    @State private var directionName = ""
    @State private var scales = false
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0)
            
            VStack {
                Text("New \(stepsType.rawValue)")
                    .padding(.bottom, 5)
                    .font(.custom("TypoRoundBoldDemo", size: 18, relativeTo: .body))
                CustomTextField(text: self.stepsType == .Ingredient ? $ingredientName : $directionName, isFirstResponder: true, placeholder: self.stepsType == .Ingredient ? "Name" : "Direction")
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .padding(8)
                    .background(Color(#colorLiteral(red: 0.9968960881, green: 0.9921532273, blue: 1, alpha: 1)))
                    .cornerRadius(8)
                    .padding(.bottom, self.stepsType == .Ingredient ? 5 : 8)
                if self.stepsType == .Ingredient {
                    CustomTextField(text: $ingredientAmount, isFirstResponder: false, placeholder: "Amount")
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                        .padding(8)
                        .background(Color(#colorLiteral(red: 0.9968960881, green: 0.9921532273, blue: 1, alpha: 1)))
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                }
                HStack(spacing: 10) {
                    Button(action: {
                        self.scales = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.showingPopup = false
                        }
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    Button(action: {}) {
                        Text("OK")
                            .foregroundColor(.white)
                            .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
                            .cornerRadius(10)
                    }
                }
            }
                .frame(width: UIScreen.main.bounds.width * 0.65, height: self.stepsType == .Ingredient ? 175 : 125)
                .padding(20)
                .background(Color(#colorLiteral(red: 0.9185401797, green: 0.9303612113, blue: 0.9379972816, alpha: 1)))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )
                .scaleEffect(self.scales ? 1 : 0)
                .animation(.easeIn)
        }
            .onAppear() {
                withAnimation(.easeIn) {
                    self.scales = true
                }
            }
    }
}

struct IngredientPopupView_Previews: PreviewProvider {
    static var previews: some View {
        NewStepPopupView(stepsType: .Direction, showingPopup: .constant(false))
    }
}


// MARK: - CustomTextfield
struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    var isFirstResponder: Bool = false
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "TypoRoundRegularDemo", size: 16)!)
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        if isFirstResponder && !context.coordinator.hasBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.hasBecomeFirstResponder = true
        }
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        var hasBecomeFirstResponder = false

        init(parent: CustomTextField) {
            self.parent = parent
        }

        // gets called every time we press a key
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}

