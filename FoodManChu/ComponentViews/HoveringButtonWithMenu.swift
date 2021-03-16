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
                        .font(.custom("Comfortaa-Bold", size: 14, relativeTo: .body))
                        .foregroundColor(.black)
                        .frame(width: 115)
                        .padding(15)
                        .background(MenuShape().fill(Color(#colorLiteral(red: 0.9103034735, green: 0.847887814, blue: 0.7689868808, alpha: 1))))
                        .cornerRadius(10)
                }
                
                Button(action: { self.isMenuOpen.toggle() }) {
                    Image(systemName: "plus")
                        .rotationEffect(Angle(degrees: self.isMenuOpen ? 45 : 0))
                        .font(.system(.title))
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.05, height: UIScreen.main.bounds.width * 0.05)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.5965602994, green: 0.8027258515, blue: 0.5414524674, alpha: 1)))
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
struct MenuShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}
