//
//  DropDownBannerView.swift
//  PromptApp
//
//  Created by librius on 2024-03-19.
//

import SwiftUI

struct DropDownBannerView: View {
    @StateObject var viewmodel = DropDownViewModel()

    let user : User
    
    var body: some View {
        
        ZStack(){
            if(user.isCurrentUser){
            
        }
            else{
                UserBannerView(user: user)

                HStack(){
                    Spacer()
                    
                    Button(){
                        Task{
                                try await viewmodel.removeFriend(toUser: user)
                            }
                    } label:{
                        Text("Remove")
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
        }
    }
}


