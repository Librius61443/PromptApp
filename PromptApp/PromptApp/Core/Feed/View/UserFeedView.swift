//
//  ContentView.swift
//  PromptApp
//
//  Created by librius on 2023-11-28.
//

import SwiftUI

struct UserFeedView: View {
    
    @StateObject var viewModel : FeedViewModel

    @State var selectedTab = 0
    @State var selectedTitle = String("prompt")
    @State var isShowSheet: Bool = false
    @State var commentSheet: Bool = false
    
    init(user: User){
        self._viewModel = StateObject(wrappedValue: FeedViewModel(user: user))
    }
    
    var body: some View {
        
        NavigationStack{
            ZStack(alignment: .top){
                Color.black
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                
                VStack(spacing: 7){
                    HStack(){
                        Button(){
                            withAnimation {
                                isShowSheet.toggle()
                            }
                        }label: {
                            Image("drop-down tab")
                                .aspectFill()
                                .frame(width: 30, height: 30)
                        }
                        Spacer()
                        Image("promptlogo")
                            .aspectFill()
                            .frame(width: 150, height: 60)
                        Spacer()
                        NavigationLink(){
                            CurrentUserBio(user: viewModel.user)
                                .navigationBarBackButtonHidden()
                        }label: {
                            CircularProfileView(user: viewModel.user, size: .large)
                        }
                    }
                    .padding(.horizontal, 15)
                    Text("Hey \(viewModel.username),")
                    
                    Text("your " + SelectedTitle(selectedTab: selectedTab) + " today is:")
                        .frame(width: 260, height: 30)
                    
                    
                    ZStack(alignment: .top){
                        
                        TabView(selection: $selectedTab){
                            
                            VStack(spacing: 20){
                                PromptView()
                                ScrollView(.vertical, showsIndicators: false){
                                    VStack(spacing: 20) {
                                        ForEach(Array(viewModel.promptPosts.enumerated()), id: \.element ) { (i, post) in
                                            PostView(post: post)
                                        }
                                    }
                                }
                            }.tag(0)
                            
                            VStack(spacing: 20){
                                ChallengeView()
                                ScrollView(.vertical, showsIndicators: false){
                                    VStack(spacing: 20) {
                                        ForEach(Array(viewModel.promptPosts.enumerated()), id: \.element ) { (i, post) in
                                            PostView(post: post)
                                        }
                                    }
                                }
                            }.tag(1)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .ignoresSafeArea(edges: .bottom)
                        
                        ZStack(){
                            HStack(spacing: 3){
                                ForEach((TabbedItems.allCases), id: \.self){ item in
                                    Button{
                                        selectedTab = item.rawValue
                                        
                                    } label: {
                                        CustomTabItem(title: item.title, isActive: (selectedTab == item.rawValue))
                                            
                                    }
                                }
                                .animation(.linear, value: TabbedItems.allCases)
                            }
                        }
                        .font(Font.TabFont)
                        .frame(width: 150, height: 25)
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(30)
                        .padding(.top, 37)
                        .shadow(color: Color(.black), radius: 15)

                    }
                }
                .font(Font.HeadlineFont)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("FontColor"))
                .overlay(isShowSheet ?  DropDownTabView(currentUser: viewModel.user, isShowSheet: $isShowSheet.animation()) : nil)

            }
        }
    }
    
}

extension UserFeedView{
    func CustomTabItem(title: String, isActive: Bool) -> some View{
        Text(title)
            .font(Font.TabFont)
            .frame(width: 73, height: 25)
            .foregroundColor(isActive ? Color("IconPink") : Color(.white))
            .background(isActive ? .white.opacity(0.9) : .clear)
            .cornerRadius(30)
    }
    
    func SelectedTitle(selectedTab: Int) -> String{
        if(selectedTab == 0){
            return String("prompt")
        }
        else if(selectedTab == 1){
            return String("challenge")
        }
        return String("prompt")
    }
    
}

enum TabbedItems: Int, CaseIterable{
    case prompt = 0
    case challenges
    
    var title: String{
        switch self {
        case .prompt:
            return "Prompt"
        case .challenges:
            return "Challenge"
        }
    }
}
#Preview {
    UserFeedView(user: User.Mock_User[0])
}
