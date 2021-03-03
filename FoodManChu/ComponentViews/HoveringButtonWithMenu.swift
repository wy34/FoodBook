//
//  HoveringButtonWithMenu.swift
//  FoodManChu
//
//  Created by William Yeung on 3/1/21.
//

import SwiftUI

struct HoveringButtonWithMenu: View {
    // MARK: - Properties
    @State private var isMenuOpen = false
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if self.isMenuOpen {
                    VStack {
                        Button(action: {  }) {
                            HStack {
                                Spacer()
                                Image(systemName: "square.grid.2x2")
                                Text("Category")
                                Spacer()
                            }
                        }
                        
                        Divider()
                        
                        Button(action: {  }) {
                            HStack {
                                Spacer()
                                Image(systemName: "note.text")
                                Text("Recipe")
                                Spacer()
                            }
                        }
                    }
                        .font(.custom("TypoRoundBoldDemo", size: 16, relativeTo: .body))
                        .foregroundColor(.black)
                        .frame(width: 115)
                        .padding(15)
                        .background(Arrow().fill(Color.red))
                        .cornerRadius(10)
                }
                
                Button(action: { self.isMenuOpen.toggle() }) {
                    Image(systemName: self.isMenuOpen ? "xmark" : "plus")
                        .font(.system(.headline))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.05, height: UIScreen.main.bounds.width * 0.05)
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
                .animation(.easeIn)
        }
    }
}

// MARK: - Preview
struct HoveringButtonWithMenu_Previews: PreviewProvider {
    static var previews: some View {
        HoveringButtonWithMenu()
    }
}


// MARK: - Arrow Shape
struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        let center = rect.width / 2
        
        return Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
