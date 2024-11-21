//
//  CurrentUserBio.swift
//  PromptApp
//
//  Created by librius on 2024-02-09.
//

import SwiftUI
import UIKit

struct CurrentUserBio: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel : UserBioViewModel
    
    @State private var showSheet = false
    @State private var image = UIImage()
    @State private var infoStatus = false
    @State private var isLoading = false


    
    init(user: User){
        self._viewModel = StateObject(wrappedValue: UserBioViewModel(user: user))
    }
    
    var body: some View {

//        NavigationView{}
            ZStack(alignment: .top){
                Color.black
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack(){
                    Button{
                        showSheet.toggle()
                    } label: {
                        if(self.image.isEmpty){
                            CircularProfileView(user: viewModel.user, size: .xLarge)
                        }
                        else{
                            Image(uiImage: image)
                                .aspectFill()
                                .frame(width: 165, height: 165)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                    }
                    .fullScreenCover(isPresented: $showSheet) {
                        ImagePickerView(image: $image, sourceType: .photoLibrary)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 10){
                        HStack(){
                            Text("Username:")
                                .font(Font.UserBioFont)

                            TextField( text: $viewModel.username, prompt: Text("enter username")
                                    .foregroundColor(Color("PlaceholderColor"))
                                    .font(Font.UserBioFont)
                            ){}
                                .onChange(of: viewModel.username){ username in
                                    viewModel.CheckUsername()
                                }
                            
                            Spacer()
                            
                        }
                        
                        HStack(){
                            Text("Full Name:")
                                .font(Font.UserBioFont)

                            
                            TextField(text: $viewModel.fullname, prompt: Text("enter fullname")
                                    .foregroundColor(Color("PlaceholderColor"))
                                    .font(Font.UserBioFont)
                                ){}
                                .onChange(of: viewModel.fullname){ fullname in
                                    viewModel.CheckFullname()
                                }
                            
                            Spacer()
                        }
                        
                    }
                    .font(Font.HeadlineFont)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("FontColor"))
                    .padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 0))
                    
                    Spacer()
                    
                    Button{
                        AuthService.shared.signOut()
                    } label: {
                        Text("Log out")
                            .foregroundColor(.white)
                            .font(Font.ButtonFont)
                            .frame(width: 230, height: 50)
                            .background(Color("IconPink"))
                            .cornerRadius(15)
                            .padding(.top, 13)
                    }
                    
                }
                
                if isLoading{
                    LoadingView(opacity: 0.5)
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
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        if(viewModel.CheckProfilPic(uiImage: self.image)){
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            Task {
                                try await viewModel.UpdateProfileImage(uiImage: self.image)
                                try await viewModel.updateUserData()
                                isLoading = false
                            }
                            isLoading = true
                        }
                        else if(viewModel.getInfoStatus()){
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            Task { try await viewModel.updateUserData()
                                isLoading = false
                            }
                            isLoading = true
                        }
                        else{}
                    } label: {
                        Text("save")
                            .font(Font.UserBioFont)
                            .multilineTextAlignment(.center)
                            .foregroundColor(viewModel.getInfoStatus() || viewModel.CheckProfilPic(uiImage: self.image) ? Color("IconPink") : Color(.gray))
                            .opacity(viewModel.getInfoStatus() || viewModel.CheckProfilPic(uiImage: self.image) ? 1 : 0.8)
                    }
                }
            }
    }
}

extension UIImage {
    var isEmpty: Bool {
        return size.width == 0 || size.height == 0
    }
}

#Preview {
    CurrentUserBio(user: User.Mock_User[0])
}
