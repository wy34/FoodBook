//
//  test.swift
//  FoodManChu
//
//  Created by William Yeung on 2/28/21.
//

import SwiftUI

struct test: View {
    @State private var revealDetails = false

    var body: some View {
        VStack {
            DisclosureGroup("Show Terms", isExpanded: $revealDetails) {
                Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
            }
            .padding()

            Spacer()
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
