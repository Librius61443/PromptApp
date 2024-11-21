//
//  SignupView.swift
//  PromptApp
//
//  Created by librius on 2024-01-25.
//

import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack(){
            Color.black
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack(){
                
                Image("promptlogo")
                    .aspectFill()
                    .frame(width: 230, height: 200)
                    .padding(.bottom, 27)
                
                TextField(text: $viewModel.email, prompt: Text("Enter your email").foregroundColor(Color("PlaceholderColor"))){}
                    .autocapitalization(.none)
                    .modifier(TextFieldMod())
                
                SecureField(text: $viewModel.password, prompt: Text("Create a password").foregroundColor(Color("PlaceholderColor"))){}
                    .modifier(TextFieldMod())
                
                TextField(text: $viewModel.username, prompt: Text("Create an username").foregroundColor(Color("PlaceholderColor"))){}
                    .modifier(TextFieldMod())
                
                Button{
                    Task{try await viewModel.createUser()}
                } label: {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .font(Font.ButtonFont)
                        .frame(width: 230, height: 50)
                        .background(Color("IconPink"))
                        .cornerRadius(15)
                        .padding(.top, 13)
                }
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
    SignupView()
}
