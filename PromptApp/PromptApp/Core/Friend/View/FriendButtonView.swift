//
//  FriendButtonView.swift
//  PromptApp
//
//  Created by librius on 2024-03-09.
//

import SwiftUI

struct FriendButtonView: View {
    @StateObject var viewmodel: DropDownViewModel

    let user: User
    var friendListIndex: Int?
    var isFriendView: Bool
    
    var body: some View {
        ZStack(){
            UserBannerView(user: user)
            
            HStack(){
                
                Spacer()
                
                Button(action: {
                    withAnimation { () -> () in              // << 2) !!
                        if(!isFriendView){
                            viewmodel.friendSearchList.remove(at: friendListIndex!)
                            viewmodel.searchExistUsers.append(user)
                        }
                        viewmodel.friends.remove(at: friendListIndex!)
                        
                        Task{
                            try await viewmodel.removeFriend(toUser: user)
                        }
                    }
                }){
                    Text("Remove")
                        .frame(width: 65, height: 25)
                        .background(Color.gray)
                        .opacity( 0.8 )
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                }
                .font(Font.FeedFont)
                .frame(width: 70)
                .padding(.trailing, 17)
                
            }
        }.transition(.move(edge: .leading))  
    }
}

