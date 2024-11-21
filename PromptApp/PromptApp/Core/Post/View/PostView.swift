//
//  FlipView.swift
//  PromptApp
//
//  Created by librius on 2024-05-13.
//

import SwiftUI

struct PostView: View {
    @StateObject var viewModel: PostViewModel
    @State var showSheet: Bool = false
    @State var frontDegree = 0.0
    
    init(post: Post){
        self._viewModel = StateObject(wrappedValue: PostViewModel(post: post))
    }
    
    var body: some View {
        ZStack {
            PostLayoutView(post: viewModel.post, degree: $frontDegree)
//            CommentView( degree: $backDegree)
            
            VStack() {
                Button(){
                    showSheet.toggle()
//                    print(post)
                }label:{
                    Color.clear
                        .frame(width: 330, height: 300)
                }
                Spacer()
            }
            .frame(height: 350)

        }
        .fullScreenCover(isPresented: $showSheet) {
            FlipView(isShowSheet: $showSheet, viewModel: viewModel)
        }

    }
}

//#Preview {
//    FlipView(post: Post.Mock_Post[0])
//}
