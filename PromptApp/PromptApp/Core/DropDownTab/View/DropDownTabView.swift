//
//  DropDownTabView.swift
//  PromptApp
//
//  Created by librius on 2024-02-03.
//

import SwiftUI

struct DropDownTabView: View {    
    @StateObject var viewmodel = DropDownViewModel()

    @State private var username: String = ""
    @State private var inputUsername: String = ""

    @State var isWaiting = false
    @State var selectedTab = 1
    @State var currentUser: User
    @Binding var isShowSheet: Bool

    var body: some View {
        
//        NavigationStack{
            ZStack(alignment: .top){
                Color.black
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack(){
                    
                    HStack(){
                        
                        Button {
                            self.selectedTab = 0
                        } label: {
                            if selectedTab == 0{
                                Image(systemName: "magnifyingglass")
                                    .aspectFill()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("IconPink"))
                            }
                            else{
                                Image(systemName: "magnifyingglass")
                                    .aspectFill()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            self.selectedTab = 1
                        } label: {
                            if selectedTab == 1{
                                Image(systemName: "person.2.fill")
                                    .aspectFill()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color("IconPink"))
                            }
                            else{
                                Image(systemName: "person.2")
                                    .aspectFill()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            self.selectedTab = 2
                        } label: {
                            if selectedTab == 2{
                                Image("accentMessageBubble")
                                    .aspectFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("IconPink"))
                            }
                            else{
                                Image("MessageBubble")
                                    .aspectFill()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    CustomSearchBar(searchText: $username, onClear: {
                        self.username = ""
                    })
                    .padding(.top, 10)
                    .onChange(of: username) { username in
                        viewmodel.searchFriendFunc(username: username)
                        
                        isWaiting = true
                        Task{
                            viewmodel.searchExistUsers = try await viewmodel.searchFunc(username: username)
                            viewmodel.searchRequestListFunc(username: username)
                            viewmodel.searchPendingListFunc(username: username)
                            isWaiting = false
                        }
                    }
                    
                    ZStack(){
                        TabView(selection: self.$selectedTab){
                            SuggestionView(viewmodel: viewmodel)
                                .tag(0)
                            
                            FriendView(viewmodel: viewmodel)
                                .tag(1)
                            
                            MessageView()
                                .tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea(edges: .bottom)
                        .foregroundColor(.white)
                        .opacity(username.isEmpty ? 1 : 0)
                        
                        if username.isEmpty{
                        }
                        else{
                            if selectedTab == 0{
                                SearchView(viewModel: viewmodel, username: $username, isWaiting: $isWaiting)
                            }
                            else if selectedTab == 1{
                                FriendSearchView(viewModel: viewmodel)
                            }
                        }
                    }
                    
                    HStack(){
                        Button {
                            if username.isEmpty{
                                isShowSheet = false
                            }
                            else{
                                self.username = ""
                            }
                        } label: {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(.white))
                            //                                .opacity(1)
                                .overlay(
                                    Image("Back icon")
                                        .aspectFill()
                                        .frame(width: 30, height: 30)
                                )
                        }
                        //                        .shadow(color: Color(.white), radius: 6, x: 0, y: 7)
                        
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                }
                .ignoresSafeArea(.keyboard)
            }
            .transition(.move(edge: .leading))
//        }
    }
}

//#Preview {
//    DropDownTabView(currentUser: <#User#>, isShowSheet: <#Binding<Bool>#>)
//}
