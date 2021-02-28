//
//  SideMenu.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct Menu: View {
    let width: CGFloat
    let isOpen: Bool
    let menuClose: () -> Void
    
    var body: some View {
        ZStack {
            Color(isOpen ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2966769873) : .clear)
                .animation(Animation.easeIn.delay(0.15))
                .onTapGesture {
                    self.menuClose()
                }
            HStack {
                MenuContent()
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.default)

                Spacer()
            }
        }
            .edgesIgnoringSafeArea(.all)
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(width: 200, isOpen: true, menuClose: {
            print("akdsf;")
        })
    }
}
