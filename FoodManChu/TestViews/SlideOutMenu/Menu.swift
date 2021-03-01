//
//  SideMenu.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

//import SwiftUI
//
//struct Menu: View {
//    // MARK: - Properties
//    let width: CGFloat
//    
//    // MARK: - Body
//    var body: some View {
//        ZStack {
//            Color(menuController.isMenuOpen ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2966769873) : .clear)
//                .animation(Animation.easeIn.delay(0.15))
//                .onTapGesture {
//                    self.menuController.isMenuOpen = false
//                }
//            HStack {
//                MenuContent()
//                    .frame(width: self.width)
//                    .background(Color.white)
//                    .offset(x: self.menuController.isMenuOpen ? 0 : -self.width)
//                    .animation(.default)
//
//                Spacer()
//            }
//        }
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//// MARK: - Previews
//struct Menu_Previews: PreviewProvider {
//    static var previews: some View {
//        Menu(width: 150)
//    }
//}
