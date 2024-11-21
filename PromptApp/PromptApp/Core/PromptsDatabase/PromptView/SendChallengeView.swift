//
//  SendChallengeView.swift
//  PromptApp
//
//  Created by librius on 2024-05-06.
//

import SwiftUI

struct SendChallengeView: View {
    @State private var challenge: String = ""
    @ObservedObject var viewModel: PromptsData
    @State private var select: Bool = false

    var body: some View {
        ZStack(alignment: .bottom){
            
            VStack(){
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack(alignment: .leading , spacing: 10) {
                        ForEach(Array(viewModel.friends.enumerated()), id: \.element) { (i, user) in
                            SelectionCheckList(viewModel: viewModel, user: user)
                        }
                    }
                }
            }
            
            VStack(){
                Spacer()
                HStack(){
                    CustomMessageBar(message: $challenge, placeholderText: "Challenge", onClear: {
                        self.challenge = ""
                    })
                    .onChange(of: challenge){ challenge in
                        self.challenge = challenge
                    }
                    
                    if(self.challenge.isEmpty || viewModel.selectedIndex.isEmpty){
                        Image(systemName: "arrow.turn.right.up")
                            .aspectFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(.gray))
                            .opacity(0.8)
                            .padding(.trailing, 25)
                            .padding(.bottom, 10)
                    }
                    else{
                        Button(){
                            Task{
                                try await viewModel.sendChallenge(myChallenge: challenge)
                            }
                        } label: {
                            Image(systemName: "arrow.turn.right.up")
                                .aspectFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("IconPink"))
                        }
                        .padding(.trailing, 25)
                        .padding(.bottom, 10)
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }
}


