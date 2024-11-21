//
//  SignUpViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-02-03.
//

import Foundation

class AuthViewModel: ObservableObject{
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    @MainActor
    func createUser() async throws{
        try await AuthService.shared.createUser(email: email, password: password, username: username)
        
        username = ""
        email = ""
        password = ""
    }
    
    func Login() async throws{
        try await AuthService.shared.Login(withEmail: email, password: password)
    }
    
}
