//
//  PostView.swift
//  PromptApp
//
//  Created by librius on 2024-01-24.
//

import SwiftUI
import Kingfisher

struct PostLayoutView: View {

    let post: Post
    @Binding var degree : Double

    var body: some View {
        ZStack(alignment: .top){
            Color(.white)
            if let imageURL = post.imageURL{
                    KFImage(URL(string: imageURL))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 310, height: 310)
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.top, 15)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
//                                        .padding(.bottom, 60)
                    //                    .border(Color.white, width: 10)
                }
                else {
                    Image("TempPic")
                        .aspectFit()
                        .frame(width: 310, height: 310)
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.top, 15)
                        .padding(.trailing, 5)
                        .padding(.leading, 5)
//                        .padding(.bottom, 60)
                    
                    //                    .border(Color.white, width: 10)
                }
                
                VStack(){
                    Spacer()
                    HStack(spacing: 5){
                            NavigationLink(){
                                if(post.user!.isCurrentUser){
                                    CurrentUserBio(user: post.user!)
                                        .navigationBarBackButtonHidden()
                                }
                                else{
                                    UserBio(user: post.user!)
                                        .navigationBarBackButtonHidden()
                                }
                            }label: {
                                CircularProfileView(user: post.user! , size: .small)
                                    .padding(.leading, 9)
                                    .padding(.bottom, 7)
                            }
                            VStack(alignment: .leading){
                                Text(post.user!.username )
                                Text("Promt: " + (post.promt))
                            }
//                            .padding(.leading, 3)
                            Spacer()
                    }
                    .font(Font.FeedFont)
                    .foregroundColor(Color.black)
//                                    .padding(.bottom, 5)
                    
                }
            }
            .frame(width: 340, height: 385)
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
}




