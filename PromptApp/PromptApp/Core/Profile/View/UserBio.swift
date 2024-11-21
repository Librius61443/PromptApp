//
//  UserBio.swift
//  PromptApp
//
//  Created by librius on 2024-01-16.
//

import SwiftUI

struct UserBio: View {
    @Environment(\.dismiss) var dismiss
//    @ObservedObject private var username = User()
    @State private var showSheet = false
    @State private var image = UIImage()
    @State private var username: String = ""
    @State private var name: String = ""
    
    @StateObject var viewModel : UserBioViewModel

    init(user: User){
        self._viewModel = StateObject(wrappedValue: UserBioViewModel(user: user))
    }
    
    var body: some View {

//        NavigationView{}
            ZStack(alignment: .top){
                Color.black
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack(){
                    
                    CircularProfileView(user: viewModel.user, size: .xLarge)
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack(){
                            Text("Username:")
                                .font(Font.UserBioFont)

                                Text(viewModel.username)
                                    .font(Font.UserBioFont)
                                    .foregroundColor(Color("PlaceholderColor"))
                            Spacer()
                            
                        }
                        
                        HStack(){
                            Text("Full Name:")
                                .font(Font.UserBioFont)

                            
                                Text(viewModel.fullname)
                                    .font(Font.UserBioFont)
                                    .foregroundColor(Color("PlaceholderColor"))
                            
                            Spacer()
                        }
                        
                    }
                    .font(Font.HeadlineFont)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("FontColor"))
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                }
        }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Image("Back icon")
                            .aspectFill()
                            .frame(width: 30, height: 30)
                    }
                }
            }
    }
}

#Preview {
    UserBio(user: User.Mock_User[0])
}

