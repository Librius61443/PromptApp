//
//  TestPromptMaker.swift
//  PromptApp
//
//  Created by librius on 2024-04-09.
//

import SwiftUI

struct PromptView: View {
    @StateObject var viewModel = PromptsData()
    @State var prompt = String()
    
    var body: some View {
        
        if(viewModel.postStatus == true){
            Text(viewModel.prompt)
                .font(Font.PromptFont)
                .frame(width: 290, height: 30)
                .foregroundColor(.gray)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
        
        else if(viewModel.postStatus == false){
            NavigationLink(){
                CameraMainView()
                    .navigationBarBackButtonHidden()
            }label: {
                Text(viewModel.prompt)
                    .font(Font.PromptFont)
                    .frame(width: 290, height: 30)
                    .foregroundColor(Color("IconPink"))
            }
        }
    }
}

//#Preview {
//    TestPromptMaker()
//}
