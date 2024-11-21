//
//  RequestListView.swift
//  PromptApp
//
//  Created by librius on 2024-03-08.
//

import SwiftUI

struct RequestsView: View {
    @StateObject var viewmodel: DropDownViewModel

    let user : User
    var requestListIndex: Int?
    var isFriendView: Bool

    var body: some View {
        
        ZStack(){
            UserBannerView(user: user)
            
                HStack(){
                    Spacer()
                    
                    Button(action: {
                        withAnimation { () -> () in              // << 2) !!
                            if(!isFriendView){
                                viewmodel.requestSearchList.remove(at: requestListIndex!)
                                viewmodel.friendSearchList.append(user)
                            }
                            viewmodel.requestList.remove(at: requestListIndex!)
                            viewmodel.friends.append(user)

                            Task{
                                try await viewmodel.addFriend(toUser: user)
                            }
                        }
                    }){
                        Text("Accept")
                            .frame(width: 65, height: 25)
                            .background(Color.gray)
                            .opacity( 0.8 )
                            .foregroundColor(Color.white)
                            .cornerRadius(30)
                    }
                    .font(Font.FeedFont)
                    .frame(width: 70)
                    .padding(.trailing, 15)
                    
                }
           
        }.transition(.move(edge: .leading))  
    }
}
