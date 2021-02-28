//
//  SlideOutMenu.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct MenuContent: View {
    var body: some View {
        List {
            Button(action: {  }) {
                Image(systemName: "house")
//                    .foregroundColor(self.selection == 0 ? .white : .black)
//                    .frame(width: screen.width / 3)
            }
            Button(action: {  }) {
                Image(systemName: "book")
//                    .foregroundColor(self.selection == 0 ? .white : .black)
//                    .frame(width: screen.width / 3)
            }
            Button(action: {  }) {
                Image(systemName: "globe")
//                    .foregroundColor(self.selection == 0 ? .white : .black)
//                    .frame(width: screen.width / 3)
            }
        }
    }
}

struct SlideOutMenu_Previews: PreviewProvider {
    static var previews: some View {
        MenuContent()
    }
}



