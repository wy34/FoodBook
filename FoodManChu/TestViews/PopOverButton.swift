//
//  ContentView.swift
//  FoodManChu
//
//  Created by William Yeung on 3/1/21.
//

import SwiftUI

struct PopOverButton: View {
    var body: some View {
        Home()
    }
}

struct PopOverButton_Previews: PreviewProvider {
    static var previews: some View {
        PopOverButton()
    }
}

struct Home: View {
    @State private var show = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Text("PopOver")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                    .padding(.top, 75)
                .padding([.horizontal, .bottom])
                    .background(Color.purple)
                
                Spacer()
            }
                .edgesIgnoringSafeArea(.top)

            VStack {
                if self.show {
                    PopOver()
                        .background(Color.white)
                        .clipShape(ArrowShape())
                        .cornerRadius(15)
                }

                
                Button(action: { self.show.toggle() }) {
                    Image(systemName: self.show ? "xmark" : "arrow.up")
                        .resizable()
                        .frame(width: 20, height: 22)
                        .foregroundColor(.purple)
                        .padding()
                }
                    .background(Color.white)
                    .clipShape(Circle())
            }
                .padding()
                .animation(.easeIn)
        }
            .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}


struct PopOver: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Button(action: {}) {
                HStack(spacing: 15) {
                    Spacer()
                    Image(systemName: "house")
                    Text("Home")
                    Spacer()
                }
            }
            
            Divider()
            
            Button(action: {}) {
                HStack(spacing: 15) {
                    Spacer()
                    Image(systemName: "house")
                    Text("Home")
                    Spacer()
                }
            }
            
            Divider()
            
            Button(action: {}) {
                HStack(spacing: 15) {
                    Spacer()
                    Image(systemName: "house")
                    Text("Home")
                    Spacer()
                }
            }
            
            Divider()
            
            Button(action: {}) {
                HStack(spacing: 15) {
                    Spacer()
                    Image(systemName: "house")
                    Text("Home")
                    Spacer()
                }
            }
        }
            .foregroundColor(.black)
            .frame(width: 135)
            .padding()
            .padding(.bottom, 20)
    }
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = rect.width / 2
        
        return Path() { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
            
            path.addLine(to: CGPoint(x: center + 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: center, y: rect.height - 5))
            path.addLine(to: CGPoint(x: center - 15, y: rect.height - 20))
            
            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
        }
    }
}
