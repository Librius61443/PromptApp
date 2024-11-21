//
//  LogInView.swift
//  PromptApp
//
//  Created by librius on 2024-01-24.
//

import SwiftUI


struct LogInView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel


    var body: some View {
        
        NavigationStack{
            ZStack(alignment: .top){
                Color.black
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                
                VStack(){
                    
                    Spacer()
                    
                    Image("promptlogo")
                        .aspectFill()
                        .frame(width: 230, height: 200)
                    
                    VStack(){
                        
                        Button{
                            print("forgot password clicked")
                        } label: {
                            Text("Forgot Password?")
                                .foregroundColor(Color("IconPink"))
                                .font(Font.FeedFont)
                                .padding(.trailing, 25)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        TextField(text: $viewModel.email, prompt: Text("Enter your email").foregroundColor(Color("PlaceholderColor"))){}
                            .autocapitalization(.none)
                            .modifier(TextFieldMod())
                        
                        SecureField(text: $viewModel.password, prompt: Text("Enter your password").foregroundColor(Color("PlaceholderColor"))){}
                            .modifier(TextFieldMod())
                            
                        Button{
                            Task{try await viewModel.Login()}
                        } label: {
                            Text("Login")
                                .foregroundColor(.white)
                                .font(Font.ButtonFont)
                                .frame(width: 230, height: 50)
                                .background(Color("IconPink"))
                                .cornerRadius(15)
                                .padding(.top, 13)
                        }
                    }
                    
                    Spacer()
                    Divider()
                    
                    NavigationLink{
                        SignupView()
                            .navigationBarBackButtonHidden()                        
                    }label: {
                        Text("Don't have an account?")
                            .font(Font.FeedFont)


                        Text("Sign up")
                            .font(Font.custom("Inter-Bold", size: 17))
                    }
                    .foregroundColor(Color("IconPink"))
                }
                
            }
        }
        
    }
}

#Preview {
    LogInView()
}
