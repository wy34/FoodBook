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
                }
                    .cornerRadius(20)
                    .padding(5)
                
                Button(action: { self.dismissModal() }) {
                    RoundedButtonView(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner], bgColor: #colorLiteral(red: 1, green: 0.4903432131, blue: 0.4654182792, alpha: 1), cornerRadius: 20)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: SFSymbols.xmark)
                                .font(.title)
                                .foregroundColor(.white)
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
    
    // MARK: - Helpers
    func dismissModal() {
        self.showScaling.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.modalManager.isRecipeDetailViewShowing = false
        }
    }
}

// MARK: - Previews
struct CustomModalView_Previews: PreviewProvider {
    static var previews: some View {
        CustomModalView(content: Color.red)
            .environmentObject(ModalManager())
    }
}

