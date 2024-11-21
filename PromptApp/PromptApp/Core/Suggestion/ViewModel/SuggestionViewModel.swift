//
//  SuggestionViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-03-15.
//

import Foundation
import Firebase
import SwiftUI

class SuggestionViewModel: ObservableObject{
    @Published var suggestionUsers = [User: Int] ()
    @Published var friendsOfFriends = [String: Int]()
    @Published var pendingRequests = [User] ()
    @Published var friends = [User] ()
    @Published var requestList = [User] ()
    
    @Published var uid = String()
    @Published private var userData = [String: Any]()
    @Published private var currentUserData = [String: Any]()
    @Published var requestedUserID = [String] ()
    
    init(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        self.uid = uid
        updatePendingList()

        Task {
            try await fetchFriends()
            try await fetchAllRequest()
            try await fetchFriendsOfFriends()
        }
    }
    
    @MainActor
    func sendFriendRequest(toUser: User) async throws{
        
        //requestList r for requesting recieved from other users
        //pendings r for request that sent to other users
        
        let requestListRef = Firestore.firestore().collection("user").document(toUser.id).collection("requestList").document(uid)
        let pendingRequestsRef = Firestore.firestore().collection("user").document(uid).collection("pendingRequests").document(toUser.id)
        
        currentUserData["ownerUID"] = toUser.id
        userData["ownerUID"] = uid
        
        try await requestListRef.setData(userData)
        try await pendingRequestsRef.setData(currentUserData)
    }
    
    @MainActor
    func removeFriendRequest(toUser: User) async throws{
                        
        let requestListRef = Firestore.firestore().collection("user").document(toUser.id).collection("requestList").document(uid)
        let pendingRequestsRef = Firestore.firestore().collection("user").document(uid).collection("pendingRequests").document(toUser.id)
       
        try await requestListRef.delete()
        try await pendingRequestsRef.delete()

    }
    
    @MainActor
    func fetchFriends() async throws{
        self.friends = []
        var stringArray: [String] = []
        
        stringArray = try await UserService.fetchFriends(withUid: uid)
                
        if stringArray.isEmpty{
            self.friends = []
        }
        else{
            for i in 0 ..< stringArray.count {
                let requestUsers = try await UserService.fetchUser(withUid: stringArray[i])
                self.friends.append(requestUsers)
            }
        }
    }
    
    @MainActor
    func fetchAllRequest() async throws{
        self.requestList = []

        let querySnapshot = try await Firestore.firestore().collection("user").document(uid).collection("requestList").getDocuments()
        
        if querySnapshot.isEmpty{
            self.requestList = []
        }
        else{
            for document in querySnapshot.documents {
                if let stringValue = document.data()["ownerUID"] as? String {
                    let requestUsers = try await UserService.fetchUser(withUid: stringValue)
                    self.requestList.append(requestUsers)
                }
            }
            
        }
    }
    
    @MainActor
    func fetchSuggestionUsers() async throws{
        let mergeArray = friends + requestList + pendingRequests

        for (key,value) in friendsOfFriends {
            let requestUsers = try await UserService.fetchUser(withUid: key)
            self.suggestionUsers[requestUsers] = value
        }
        
        for key in mergeArray{
            self.suggestionUsers.removeValue(forKey: key)
        }
    }
    
    @MainActor
    func fetchFriendsOfFriends() async throws{
        
        var stringArray: [String] = []
        var friendsOfFriendId: [String] = []
        
        stringArray = try await UserService.fetchFriends(withUid: uid)
                
        if stringArray.isEmpty{
            self.suggestionUsers = [:]
            self.friendsOfFriends = [:]
        }
        else{
            for i in 0 ..< stringArray.count {
                friendsOfFriendId += try await UserService.fetchFriends(withUid: stringArray[i])
            }
        }
        
        self.friendsOfFriends = findRepeatedId(friendsOfFriendId)
        
        try await fetchSuggestionUsers()
    }
    
    func findRepeatedId(_ array: [String]) -> [String: Int] {
        // Create a dictionary to store counts of each string
        var counts = [String: Int]()
        
        // Count occurrences of each string
        for string in array {
            counts[string, default: 0] += 1
        }
        
        // Filter out the repeated strings
        let repeatedStrings = counts.filter { $0.value > 1 }
        
        // Create a dictionary to store repeated strings and their counts
        var repeatedStringsDictionary = [String: Int]()
        
        // Convert the filtered results to a dictionary
        for (string, count) in repeatedStrings {
            if(string == uid){
                
            }else{
                repeatedStringsDictionary[string] = count
            }
        }
        
        return repeatedStringsDictionary
    }
    
    @MainActor
    func fetchAllPendings() async throws{
        self.pendingRequests = []

        let querySnapshot = try await Firestore.firestore().collection("user").document(uid).collection("pendingRequests").getDocuments()
        
        if querySnapshot.isEmpty{
            self.pendingRequests = []
        }
        else{
            for document in querySnapshot.documents {
                if let stringValue = document.data()["ownerUID"] as? String {
                    let requestUsers = try await UserService.fetchUser(withUid: stringValue)
                    self.pendingRequests.append(requestUsers)
                }
            }
            
        }
    }
    
    private func updatePendingList() {
        
        Firestore.firestore().collection("user").document(uid).collection("pendingRequests").addSnapshotListener { querySnapshot, error in
            if let error = error {
                  print("Error retreiving collection: \(error)")
                }
            Task{
                try await self.fetchAllPendings()
            }
          }
    }
}

