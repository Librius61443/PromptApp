//
//  SearchBar.swift
//  PromptApp
//
//  Created by librius on 2024-02-07.
//

import SwiftUI

struct SuggestionView: View {
    @ObservedObject var viewmodel: DropDownViewModel
    
    var body: some View {
        
        NavigationStack{
            ZStack(alignment: .top){
                Color(.black)
                    .ignoresSafeArea(.all)
                
                VStack(){
                    Text("Suggestion")
                        .font(Font.HeadlineFont)
                    Rectangle()
                        .frame(width: 325, height: 3 )
                    
                    Spacer()
                    
                    if viewmodel.suggestionUsers.isEmpty{
                        //                            Spacer()
                        
                        Text("There is no suggestion")
                            .foregroundColor(.gray)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                            .font(Font.FeedFont)
                        
                        //                            Spacer()
                    }
                    else{
                        
                        ScrollView(.vertical, showsIndicators: false){
                            LazyVStack(spacing: 10) {
                                ForEach(viewmodel.suggestionUsers.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                    SuggestionBannerView(viewmodel: viewmodel, user: key, mutualNumber: value, isSuggestionView: true)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .animation(.linear, value: viewmodel.suggestionUsers)
                        
                    }
                    
                    Spacer()
                    
                    if viewmodel.pendingList.isEmpty{
                        
                    }
                    else{
                        Text("Pendings")
                            .font(Font.HeadlineFont)
                        Rectangle()
                            .frame(width: 325, height: 3 )
                        
                        ScrollView(.vertical, showsIndicators: false){
                            LazyVStack(spacing: 10) {
                                ForEach(Array(viewmodel.pendingList.enumerated()), id: \.element) { (i, user) in
                                    PendingRequestsView(viewmodel: viewmodel, user: user, pendingIndex: i, isSuggestionView: true)
                                }
                            }
                        }
                        .padding(.top, 15)
                        .animation(.linear, value: viewmodel.pendingList)
//                        .transition(.move(edge: .leading))
                    }
                }
                .foregroundColor(.white)
                .padding(.top, 15)
                
            }
            
        }
    }
}

//#Preview {
//    SuggestionView()
//}
