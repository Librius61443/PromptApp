//
//  FullCmtView.swift
//  PromptApp
//
//  Created by librius on 2024-07-07.
//

import SwiftUI

struct FullCmtView: View {
    @ObservedObject var viewModel: PostViewModel

    var namespace: Namespace.ID
    @Binding var isShowSheet: Bool
    @State private var comment: String = ""
    @State private var replying: Bool = false
    @State private var replyingID: String = ""
    @State private var reply: Comment = Comment.Mock_Comment[0]

    var body: some View {

            ZStack(){
                Color(.white)
                    .ignoresSafeArea()
                
                VStack(){
                    HStack(){
                        Button {
                            isShowSheet.toggle()
                        } label: {
                            Image("Back icon")
                                .aspectFill()
                                .frame(width: 30, height: 30)
                        }
                        .padding(.leading, 15)
                        Spacer()
                    }
                    Spacer()
                    
                    ScrollView(.vertical, showsIndicators: true){
                        VStack(spacing: 20) {
                            ForEach(Array(viewModel.comments.enumerated()), id: \.element) { (i, comment) in
                                Group{
                                    CommentView(comment: comment, replying: $replying, reply: $reply)
                                    ReplyView(comment: comment, reply: $reply)
                                }
                            }
                        }
                    }
                    
                    VStack(){
                        if(replying == true){
                            Text("replying to: " + reply.owner!.username + "-" + reply.comment)
                                .multilineTextAlignment(.leading).foregroundColor(Color.black)
                                .lineLimit(1)
                                .font(Font.TabFont)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)


                        }
                        HStack(alignment: .bottom){
                            
                            MultiLineTextField(inputText: $comment)
                            
                            
                            if(self.comment.isEmpty){
                                Image(systemName: "arrow.turn.right.up")
                                    .aspectFill()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color(.gray))
                                    .opacity(0.8)
                                    .padding(.trailing, 10)
                                    .padding(.bottom, 10)
                                    .padding(.leading, 35)
                                
                            }
                            else{
                                Button(){
                                    Task{
                                        if(replying == true){
                                            try await viewModel.addAReply(stringReply: comment, cmtID: replyingID)
                                        }
                                        else{
                                            try await viewModel.addAComment(stringComment: comment)
                                        }
                                        comment = ""
                                    }
                                } label: {
                                    Image(systemName: "arrow.turn.right.up")
                                        .aspectFill()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color("IconPink"))
                                }
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 35)
                                
                            }
                        }
                    }
                    
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                        .frame(minHeight: 20)
                    }
            
                
            }
            .background(){
                Rectangle()
                    .matchedGeometryEffect(id: "cmtView", in: namespace)
                    .transition(.scale(scale: 1))
            }
        }
        
}

//#Preview {
//    FullCmtView()
//}
