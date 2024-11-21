//
//  FeedViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-02-20.
//

import Foundation
import Firebase
import SwiftUI

class FeedViewModel: ObservableObject{
    @Published var promptPosts = [Post]()
    @Published var user : User
    @Published var username = ""
    @Published var prompt = ""
    @Published var uid = String()
    
    @MainActor
    init(user: User){
        self.user = user
        
        self.uid = user.id

        self.username = user.username
                
        updateUser()
        updatePosts()
        
    }
    
    @MainActor
    func fetchCurrentUser(userID: String) async throws{
        self.user = try await UserService.fetchUser(withUid: userID)
        self.username = user.username
    }
    
    @MainActor
    func fetchPosts() async throws -> [Post]{
        var stringArray: [String] = []
        var promptPosts: [Post] = []
        
        stringArray.append(uid)
        stringArray += try await UserService.fetchFriends(withUid: user.id)
            
        for i in 0 ..< stringArray.count {
            let snapshot = try await Firestore.firestore().collection("PromptPosts").whereField("ownerUID", isEqualTo: stringArray[i]).order(by: "timeStamp", descending: true).limit(to: 1).getDocuments()
            let post = try snapshot.documents.compactMap({ try $0.data(as: Post.self)})
            promptPosts += post
        }
        
        for x in 0 ..< promptPosts.count {
            let post = promptPosts[x]
            let ownerUid = post.ownerUID
            let postUser = try await UserService.fetchUser(withUid: ownerUid)
            promptPosts[x].user = postUser
        }
        
        return promptPosts
    }
    
    @MainActor
    private func updatePosts() {
        
        Firestore.firestore().collection("PromptPosts").addSnapshotListener { querySnapshot, error in
            if let error = error {
                  print("Error retreiving posts collection: \(error)")
                }
            else{
                Task{
                    self.promptPosts = try await self.fetchPosts()
                }
            }
          }
    }
    
    private func updateUser() {
        
        Firestore.firestore().collection("user").document(uid).addSnapshotListener { querySnapshot, error in
            if let error = error {
                  print("Error retreiving users collection: \(error)")
                }
            Task{
                try await self.fetchCurrentUser(userID: self.uid)
//                try await self.fetchPosts()
            }
          }
    }
    
}
