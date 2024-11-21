//
//  CommentView.swift
//  PromptApp
//
//  Created by librius on 2024-07-27.
//

import SwiftUI

struct CommentView: View {
    @State var comment: Comment
    @Binding var replying: Bool
    @Binding var reply: Comment

    var body: some View {
        HStack(){
            NavigationLink(){
                if(comment.owner!.isCurrentUser){
                    CurrentUserBio(user: comment.owner!)
                        .navigationBarBackButtonHidden()
                }
                else{
                    UserBio(user: comment.owner!)
                        .navigationBarBackButtonHidden()
                }
            }label: {
                CircularProfileView(user: comment.owner!, size: .small)
            }
            
            VStack(alignment: .leading, spacing: 5){
                NavigationLink(){
                    if(comment.owner!.isCurrentUser){
                        CurrentUserBio(user: comment.owner!)
                            .navigationBarBackButtonHidden()
                    }
                    else{
                        UserBio(user: comment.owner!)
                            .navigationBarBackButtonHidden()
                    }
                }label: {
                    Text(comment.owner!.username)
                        .font(Font.TabFont)
                        .foregroundColor(Color("IconPink"))
                }
                Text(comment.comment)
                    .font(Font.FeedFont)
                    .foregroundColor(.black)
                    .lineLimit(1...4)
                    .multilineTextAlignment(.leading)
                Button(){
                    replying = true
                    reply = comment
                }label:{
                    Text("Reply")
                        .font(Font.TabFont)
                        .foregroundColor(.gray)
                }
                
            }
//                                    .padding(.top, 5)
            .offset(y: 5)
            
            Spacer()
        }
        .padding(.leading, 20)

    }
}

//#Preview {
//    CommentView()
//}
