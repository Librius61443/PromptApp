//
//  MessageView.swift
//  PromptApp
//
//  Created by librius on 2024-02-07.
//

import SwiftUI

struct MessageView: View {
//    @StateObject var viewmodel = SearchViewModel()

    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                Color(.black)
                    .ignoresSafeArea(.all)
                
//                VStack(){
//                    Text("Messages")
//                        .font(Font.HeadlineFont)
//                    Rectangle()
//                        .frame(width: 325, height: 3 )
//                    
//                    ScrollView(.vertical, showsIndicators: false){
//                        VStack(spacing: 10) {
//                            ForEach(viewmodel.users) { user in
//                                NavigationLink(){
//                                    if(user.isCurrentUser){
//                                        CurrentUserBio(user: user)
//                                            .navigationBarBackButtonHidden()
//                                    }
//                                    else{
//                                        UserBio(user: user)
//                                            .navigationBarBackButtonHidden()
//                                    }
//                                }label: {
//                                    HStack(){
//                                        
//                                        CircularProfileView(user: user, size: .small)
//                                            .padding(.leading, 9)
//                                            .padding(.bottom, 7)
//                                        VStack(alignment: .leading){
//                                            Spacer()
//                                            Text(user.username)
//                                            Text(user.fullname ?? "")
//                                            Spacer()
//                                        }
//                                        //                            .padding(.bottom, 4)
//                                        Spacer()
//                                    }
//                                    .font(Font.FeedFont)
//                                    .foregroundColor(Color.white)
//                                    .padding(.horizontal)
//                                }
//                                
//                            }
//                        }
//                    }
//                    .padding(.top, 15)
//                }
                .foregroundColor(.white)
                .padding(.top, 15)
            }
        }
    }
}

#Preview {
    MessageView()
}
