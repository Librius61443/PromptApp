//
//  SelectionCheckList.swift
//  PromptApp
//
//  Created by librius on 2024-05-08.
//

import SwiftUI

struct SelectionCheckList: View {
    @ObservedObject var viewModel: PromptsData
    let user: User
    @State private var selected: Bool = false
    var body: some View {
        HStack(){
            
            Button(){
                selected.toggle()
                if(selected == true){
                    viewModel.selectedIndex.append(user)
                }
                else{
                    viewModel.UnselectFriend(user: user)
                }
            }label: {
                UserBannerView(user:user)
            }
            
            Spacer()
            
            if(selected == true){
                Image(systemName: "checkmark.circle.fill")
                    .aspectFill()
                    .frame(width: 20, height: 20)
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(.black, .white)
                    .foregroundColor(.black)
            }
            else{
                Image(systemName: "circle")
                    .aspectFill()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            
        }
        .padding(.leading, 5)
        .padding(.trailing, 20)
        .padding(.top, 15)
        
        Divider()
            .frame(height: 2)
    }
}

