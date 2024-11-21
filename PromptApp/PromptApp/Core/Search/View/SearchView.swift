//
//  SwiftUIView.swift
//  PromptApp
//
//  Created by librius on 2024-03-19.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: DropDownViewModel
    
    @State var isLoading = false
    @Binding var username: String
    @Binding var isWaiting: Bool
    
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
                                    FriendButtonView(viewmodel: viewModel, user: user, friendListIndex: i, isFriendView: false)
                                }.animation(.linear, value: viewModel.friendSearchList)
                            }
                        }
                            
                        
                        if(viewModel.searchExistUsers.isEmpty){
                            
                        }else{
                            Text("Search")
                                .font(Font.HeadlineFont)
                            Rectangle()
                                .frame(width: 325, height: 3 )
                            
                            VStack(spacing: 10){
                                ForEach(Array(viewModel.searchExistUsers.enumerated()), id: \.element) { (i, user) in
                                    SuggestionBannerView( viewmodel: viewModel, user: user, mutualNumber: 0, searchIndex: i, isSuggestionView: false)
                                }.animation(.linear, value: viewModel.searchExistUsers)

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
                        
                        if(viewModel.pendingSearchList.isEmpty){
                            
                        }else{
                            Text("Pendings")
                                .font(Font.HeadlineFont)
                            Rectangle()
                                .frame(width: 325, height: 3 )
                            
                            VStack(spacing: 10){
                                ForEach(Array(viewModel.pendingSearchList.enumerated()), id: \.element) { (i, user) in
                                    PendingRequestsView(viewmodel: viewModel, user: user, pendingIndex: i, isSuggestionView: false)
                                }.animation(.linear, value: viewModel.pendingSearchList)

                            }
                        }
                        
                        if(isWaiting){
                        }
                        else if(viewModel.friendSearchList.isEmpty && viewModel.requestSearchList.isEmpty && viewModel.pendingSearchList.isEmpty && viewModel.searchExistUsers.isEmpty){
                            Text("acount \"\(username)\" don't exist")
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.top, 15)
                }
                
//                if(isLoading){
//                    LoadingView(opacity: 0.5)
//                }
            }
        }
    }
}

extension SearchView{
    func CustomTabItem(title: String, isActive: Bool) -> some View{
        Text(title)
            .font(Font.FeedFont)
            .frame(width: 60, height: 25)
            .background(Color.gray)
            .opacity( 0.8 )
            .foregroundColor(Color.white)
            .cornerRadius(30)
        }
}

