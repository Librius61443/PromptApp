//
//  ContentViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-02-03.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject{
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    @MainActor
    init(){
        SetSubcribers()
    }

    @MainActor
    func SetSubcribers() {
        service.$userSession.sink {[weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
        
        service.$currentUser.sink {[weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
