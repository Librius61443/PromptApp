//
//  SuggestionBannerView.swift
//  PromptApp
//
//  Created by librius on 2024-03-15.
//

import SwiftUI

struct SuggestionBannerView: View {
    @StateObject var viewmodel: DropDownViewModel

    let user : User
    let mutualNumber: Int
    var searchIndex: Int?
    var isSuggestionView: Bool

    var body: some View {
        
        ZStack(){
            
            UserBannerView(user: user)
            
            HStack(){
                Spacer()
                
                if(mutualNumber == 0){
                    
                }
                else if(mutualNumber > 1){
                    Text(String(mutualNumber) + " in mutual")
                }
                
                if(user.isCurrentUser){
                    
                }else{
                    Button(action: {
                        withAnimation { () -> () in              // << 2) !!
                            if(!isSuggestionView){
                                viewmodel.searchExistUsers.remove(at: searchIndex!)
                                viewmodel.pendingSearchList.append(user)
                            }
                            viewmodel.suggestionUsers.removeValue(forKey: user)
                            viewmodel.pendingList.append(user)
                            Task{
                                try await viewmodel.sendFriendRequest(toUser: user)
                                
                            }
                        }
                    }){
                        Text("Add")
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


