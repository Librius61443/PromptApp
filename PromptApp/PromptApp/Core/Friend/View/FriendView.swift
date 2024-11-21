//
//  FriendView.swift
//  PromptApp
//
//  Created by librius on 2024-02-17.
//

import SwiftUI

struct FriendView: View {
    @ObservedObject var viewmodel: DropDownViewModel
    @State var isLoading = false
    var body: some View {
        NavigationStack{
            
            ZStack(alignment: .top){
                Color(.black)
                    .ignoresSafeArea(.all)
                
                
                
                VStack(){
                    
                    Text("Friends")
                        .font(Font.HeadlineFont)
                    Rectangle()
                        .frame(width: 325, height: 3 )
                    
                    Spacer()
                    
                    if(viewmodel.friends.isEmpty){
                        
//                        Spacer()
                        
                        Text("Start adding friends!")
                            .foregroundColor(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                            .font(Font.FeedFont)
                        
//                        Spacer()
                        
                    }else{
                        
                        
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(spacing: 10) {
                                ForEach(Array(viewmodel.friends.enumerated()), id: \.element) { (i, user) in
                                    
                                    FriendButtonView(viewmodel: viewmodel, user: user, friendListIndex: i, isFriendView: true)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .animation(.linear, value: viewmodel.friends)
                    }
                    
                    Spacer()
                    
                    if(viewmodel.requestList.isEmpty){
                        
                    }else{
                        Text("Request")
                            .font(Font.HeadlineFont)
                        Rectangle()
                            .frame(width: 325, height: 3 )
                        
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(spacing: 10) {
                                ForEach(Array(viewmodel.requestList.enumerated()), id: \.element) { (i, user) in
                                    
                                    RequestsView(viewmodel: viewmodel, user: user, requestListIndex: i, isFriendView: true)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .animation(.linear, value: viewmodel.requestList)

                    }
                }
                .foregroundColor(.white)
                .padding(.top, 15)
                
                if(isLoading){
                    LoadingView(opacity: 1)
                }
                
            }
        }
    }
}

//#Preview {
//    FriendView()
//}
