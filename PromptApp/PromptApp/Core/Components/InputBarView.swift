//
//  InputBarView.swift
//  PromptApp
//
//  Created by librius on 2024-05-14.
//

import SwiftUI

struct InputBarView: View {
    var body: some View {
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
                    .foregroundColor(Color(.white))
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

#Preview {
    InputBarView()
}
