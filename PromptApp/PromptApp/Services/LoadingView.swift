//
//  LoadingView.swift
//  PromptApp
//
//  Created by librius on 2024-02-25.
//

import SwiftUI

struct LoadingView: View {
    
    @State private var rotation: Double = 0
    
    @State var opacity: Double = 0.5
    var body: some View {
            ZStack{
                Color.black
                    .ignoresSafeArea()
                    .opacity(opacity)
                VStack(){
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color("IconPink"), lineWidth: 5)
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: rotation))
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                rotation = 360
                            }
                        }
                }
            }

    }
}

#Preview {
    LoadingView()
}
