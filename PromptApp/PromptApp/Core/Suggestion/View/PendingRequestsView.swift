//
//  PendingRequestsView.swift
//  PromptApp
//
//  Created by librius on 2024-04-02.
//

import SwiftUI

struct PendingRequestsView: View {
    @StateObject var viewmodel: DropDownViewModel

    let user : User
    var pendingIndex: Int?
    var isSuggestionView: Bool
    
    var body: some View {
        
        ZStack(){
            if(user.isCurrentUser){
            
        }
            else{
                UserBannerView(user: user)

                HStack(){
                    Spacer()
                    
                    Button(action: {
                        withAnimation { () -> () in              // << 2) !!
                            if(!isSuggestionView){
                                viewmodel.pendingSearchList.remove(at: pendingIndex!)
                                viewmodel.searchExistUsers.append(user)
                            }
                            viewmodel.pendingList.remove(at: pendingIndex!)
                            Task{
                                try await viewmodel.removeFriendPending(toUser: user)
                            }
                        }
                    }){
                        Text("Cancel")
                            .frame(width: 60, height: 25)
                            .background(Color.gray)
                            .opacity( 0.8 )
                            .foregroundColor(Color.white)
                            .cornerRadius(30)
                    }
                    .font(Font.FeedFont)
                    .frame(width: 70)
                    .padding(.trailing, 15)
                    
                }
            }
        }.transition(.move(edge: .leading))  
    }
}

