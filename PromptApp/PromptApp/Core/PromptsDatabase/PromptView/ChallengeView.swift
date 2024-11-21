//
//  ChalengeView.swift
//  PromptApp
//
//  Created by librius on 2024-04-17.
//

import SwiftUI

struct ChallengeView: View {
    @StateObject var viewModel = PromptsData()

    @State private var settingsDetent = PresentationDetent.medium

    @State private var isShowingPopup = false

    
    var body: some View {
        HStack(alignment: .center) {
            
            if(viewModel.challengeSelection.isEmpty){
                
            }
            else{
                CircularProfileView(user: viewModel.getUserFromValue(value: viewModel.challengeSelection), size: .xSmall)
            }
            
            NavigationLink(){
                CameraMainView()
                    .navigationBarBackButtonHidden()
            }label: {
                Text(viewModel.challengeSelection)
                    .font(Font.PromptFont)
//                    .frame(width: 290, height: 30)
                    .foregroundColor(Color("IconPink"))
            }
            .padding(.leading, 10)
            
            Button(){
                isShowingPopup.toggle()
            } label: {
                Image(systemName: "chevron.down.circle")
                    .aspectFill()
                    .frame(width: 20, height: 20)
            }
            .sheet(isPresented: $isShowingPopup) {
                PopupView(viewModel: viewModel)
                    .presentationDetents(
                        [.medium, .large],
                        selection: $settingsDetent
                    )
                    .presentationDragIndicator(.hidden)

            }
            
//            Menu{
//                
//            } label: {
//                Image(systemName: "chevron.down.circle")
//                    .aspectFill()
//                    .frame(width: 20, height: 20)
//            }
//            .menuStyle(.borderlessButton)
//            .menuIndicator(.hidden)
            
        }
    }
}

#Preview {
    ChallengeView()
}
