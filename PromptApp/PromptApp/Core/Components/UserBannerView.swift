//
//  UserBannerView.swift
//  PromptApp
//
//  Created by librius on 2024-03-09.
//

import SwiftUI

struct UserBannerView: View {
    let user: User
    var body: some View {
        
        NavigationLink(){
            if(user.isCurrentUser){
                CurrentUserBio(user: user)
                    .navigationBarBackButtonHidden()
            }
            else{
                UserBio(user: user)
                    .navigationBarBackButtonHidden()
            }
        }label: {
            HStack(){
                
                CircularProfileView(user: user, size: .small)
                    .padding(.leading, 9)
                    .padding(.bottom, 7)
                VStack(alignment: .leading){
                    Spacer()
                    Text(user.username)
                    
                    if(user.fullname != nil){
                        Text(user.fullname ?? "")
                    }
                    
                    Spacer()
                }
                //                            .padding(.bottom, 4)
                Spacer()
            }
            .font(Font.FeedFont)
            .foregroundColor(Color.white)
            .padding(.horizontal)
        }
        
    }
}

#Preview {
    UserBannerView(user: User.Mock_User[0])
}
