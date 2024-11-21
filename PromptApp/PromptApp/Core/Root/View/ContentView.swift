//
//  ContentView.swift
//  PromptApp
//
//  Created by librius on 2024-02-03.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var authViewModel = AuthViewModel()

    
    var body: some View {
        Group{
            if viewModel.userSession == nil{
                LogInView()
                    .environmentObject(authViewModel)
            }
//            else if viewModel.currentUser == nil{
//                LogInView()
//                    .environmentObject(authViewModel)
//            }
            else if let currentUser = viewModel.currentUser{
                UserFeedView(user: currentUser)
            }
            else{
                LoadingView()
            }
//            else{
//                LogInView()
//                    .environmentObject(authViewModel)
//            }
        }
    }
}

#Preview {
    ContentView()
}
