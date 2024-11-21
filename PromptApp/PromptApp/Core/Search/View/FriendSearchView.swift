//
//  FriendSearchView.swift
//  PromptApp
//
//  Created by librius on 2024-04-03.
//

import SwiftUI

struct FriendSearchView: View {
    @ObservedObject var viewModel: DropDownViewModel

    @State var isLoading = false

    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                Color(.black)
                    .ignoresSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 15){
                        if(viewModel.friendSearchList.isEmpty){
                            
                        }else{
                            Text("Friends")
                                .font(Font.HeadlineFont)
                            Rectangle()
                                .frame(width: 325, height: 3 )
                            
                            VStack(spacing: 10){
                                ForEach(Array(viewModel.friendSearchList.enumerated()), id: \.element) { (i, user) in
                                    FriendButtonView( viewmodel: viewModel, user: user, friendListIndex: i, isFriendView: false)
                                }.animation(.linear, value: viewModel.friendSearchList)
                            }
                        }
                            
                        
                        if(viewModel.requestSearchList.isEmpty){
                            
                        }else{
                            Text("Request")
                                .font(Font.HeadlineFont)
                            Rectangle()
                                .frame(width: 325, height: 3 )
                            
                            VStack(spacing: 10){
                                ForEach(Array(viewModel.requestSearchList.enumerated()), id: \.element) { (i, user) in
                                    RequestsView(viewmodel: viewModel, user: user, requestListIndex: i, isFriendView: false)
                                }.animation(.linear, value: viewModel.requestSearchList)
                            }
                        }
                        
                    }
                    .foregroundColor(.white)
                    .padding(.top, 15)
                }
            }
        }
    }
}
