//
//  PopupView.swift
//  PromptApp
//
//  Created by librius on 2024-05-05.
//

import SwiftUI

struct PopupView: View {
    @ObservedObject var viewModel: PromptsData

    @State private var isShowingPopup = false
    
    var body: some View {
    
        HStack{
            Spacer()
            
            Button(){
                isShowingPopup.toggle()
            } label: {
                Text("Challenge a friend")
                    .font(Font.FeedFont)
                    .foregroundColor(Color("IconPink"))
            }
            .padding(.top, 10)
            .padding(.trailing, 10)
            .sheet(isPresented: $isShowingPopup) {
                SendChallengeView(viewModel: viewModel)
                    .presentationDragIndicator(.visible)
            }
        }
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(alignment: .leading , spacing: 10) {
                    ForEach(viewModel.challenge.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
        
                                Button(){
                                    viewModel.challengeSelection = value
                                }label: {
                                    
                                    HStack(){
                                        UserBannerView(user: key)

                                        Spacer()
                                        
                                        Text(value)
                                            .foregroundColor((viewModel.challengeSelection == value) ? Color("IconPink") : Color(.white))
                                    }
                                    .padding(.leading, 5)
                                    .padding(.trailing, 20)
                                        
                                    
                                }

                            Divider()
                                .frame(height: 2)
                        
                       
                        
                    }
                }
                
            }
            .padding(.top, 20)

    }
}


