//
//  FullScreenCmtView.swift
//  PromptApp
//
//  Created by librius on 2024-05-14.
//

import SwiftUI

struct FlipView: View {
    @Binding var isShowSheet: Bool
    
    @State private var comment: String = ""
    @State var frontDegree = 0.0
    @State var backDegree = 90.0
    @State var isFlipped = false
    let durationAndDelay : CGFloat = 0.2
    @ObservedObject var viewModel: PostViewModel
    @Namespace private var namespace

    func flipCard (flip: Bool) {
        
        if flip {
            withAnimation(.easeInOut(duration: durationAndDelay).delay(durationAndDelay).delay(durationAndDelay)){
                isFlipped.toggle()
            }
            
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = -0
            }
            withAnimation(.linear(duration: durationAndDelay)){
                frontDegree = -90
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
            withAnimation(.linear(duration: durationAndDelay)){
                backDegree = 90
            }
        }
    }
    
    var body: some View{
        NavigationStack{
            ZStack {
                PostLayoutView(post: viewModel.post, degree: $frontDegree)
                if !isFlipped{
                    BackPostView( degree: $backDegree, namespace: namespace)
                    
                }
                else{
                    FullCmtView(viewModel: viewModel, namespace: namespace, isShowSheet: $isShowSheet)
                    
                }
                
            }
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                flipCard(flip: true)
            }
        }
        .onDisappear(){
            flipCard(flip: false)
        }
    }
}
