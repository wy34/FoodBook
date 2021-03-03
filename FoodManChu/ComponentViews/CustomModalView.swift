//
//  CustomModalView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/1/21.
//

import SwiftUI

struct CustomModalView<Content: View>: View {
    // MARK: - Properties
    let content: Content
    let screenSize = UIScreen.main.bounds
    
    @State private var showScaling = false
    @EnvironmentObject var modalManager: ModalManager

    // MARK: - Body
    var body: some View {
        ZStack {
            if self.showScaling {
                Color.black
                    .opacity(0.25)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { self.dismissModal() }
            }
            
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 10)
                    
                ScrollView(showsIndicators: false) {
                    content
                        .frame(width: screenSize.width - 50)
                }
                    .cornerRadius(20)
                    .padding(5)
                
                Button(action: { self.dismissModal() }) {
                    RoundedButtonView()
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "xmark")
                        )
                }
            }
                .scaleEffect(self.showScaling ? 1 : 0)
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
        }
            .onAppear() {
                self.showScaling = true
            }
    }
    
    // MARK: - Helper methods
    func dismissModal() {
        self.showScaling.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.modalManager.isRecipeDetailViewShowing = false
        }
    }
}

struct CustomModalView_Previews: PreviewProvider {
    static var previews: some View {
        CustomModalView(content: Color.red)
            .environmentObject(ModalManager())
    }
}

// MARK: - Rounded Corners
struct RoundedButtonView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //
    }
}