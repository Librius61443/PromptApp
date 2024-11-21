//
//  RequestListViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-03-08.
//

import Foundation
import Firebase

class FriendViewModel: ObservableObject{
    @Published var friends = [User] ()
    @Published var request = [User] ()
    
    @Published var uid = String()
    @Published private var userData = [String: Any]()
    @Published private var currentUserData = [String: Any]()
   
    @MainActor
    init(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        self.uid = uid
//        updateFriend()
        Task{
            self.friends = try await fetchFriends()
        }
        updateRequestList()
    }
    
    @MainActor
    func fetchFriends() async throws -> [User]{
        var friends = [User]()
        var stringArray: [String] = []
        
        stringArray = try await UserService.fetchFriends(withUid: uid)
                
        if stringArray.isEmpty{
            friends = []
        }
        else{
            for i in 0 ..< stringArray.count {
                let requestUsers = try await UserService.fetchUser(withUid: stringArray[i])
                friends.append(requestUsers)
            }
        }
        return friends
    }
    
    @MainActor
    func addFriend(toUser: User) async throws{
        self.friends = []
        let currentUserFriendList = Firestore.firestore().collection("user").document(uid).collection("friends").document(toUser.id)
        let userFriendList = Firestore.firestore().collection("user").document(toUser.id).collection("friends").document(uid)

        currentUserData["ownerUID"] = toUser.id
        userData["ownerUID"] = uid
       
        Task{
            try await currentUserFriendList.setData(currentUserData)
            try await userFriendList.setData(userData)
            try await removeFriendRequest(toUser: toUser)
            self.friends.append(contentsOf: try await fetchFriends())
        }
    }
    
    @MainActor
    func removeFriendRequest(toUser: User) async throws{
                        
        let pendingRequestsRef = Firestore.firestore().collection("user").document(toUser.id).collection("pendingRequests").document(uid)
        let requestListRef = Firestore.firestore().collection("user").document(uid).collection("requestList").document(toUser.id)
       
        try await requestListRef.delete()
        try await pendingRequestsRef.delete()

    }
    
    @MainActor
    func removeFriend(toUser: User) async throws{

        let requestListRef = Firestore.firestore().collection("user").document(uid).collection("friends").document(toUser.id)
        let pendingRequestsRef = Firestore.firestore().collection("user").document(toUser.id).collection("friends").document(uid)
       
        try await requestListRef.delete()
        try await pendingRequestsRef.delete()
        
    }
    
    private func updateFriend() {
        Firestore.firestore().collection("user").document(uid).collection("friends").addSnapshotListener { querySnapshot, error in
            if let error = error {
                  print("Error retreiving collection: \(error)")
                }
            Task{
                try await Task.sleep(nanoseconds: 500_000_000) //delay for animation

                try await self.fetchFriends()
            }
          }
    }
    
    @MainActor
    func fetchAllRequests() async throws{
        var stringArray: [String] = []
        self.request = []

        let querySnapshot = try await Firestore.firestore().collection("user").document(uid).collection("requestList").getDocuments()
        
        if querySnapshot.isEmpty{
            self.request = []
        }
        else{
            for document in querySnapshot.documents {
                if let stringValue = document.data()["ownerUID"] as? String {
                    stringArray.append(stringValue)
                }
            }
            
            for i in 0 ..< stringArray.count {
                let requestUsers = try await UserService.fetchUser(withUid: stringArray[i])
                self.request.append(requestUsers)
            }
        }
    }
    
    private func updateRequestList() {
        
        Firestore.firestore().collection("user").document(uid).collection("requestList").addSnapshotListener { querySnapshot, error in
            if let error = error {
                  print("Error retreiving collection: \(error)")
                }
            Task{
                try await self.fetchAllRequests()
            }
          }
    }
    
    
}
