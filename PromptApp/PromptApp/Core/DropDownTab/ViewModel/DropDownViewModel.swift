//
//  DropDownViewModel.swift
//  PromptApp
//
//  Created by librius on 2024-03-17.
//

import Foundation
import Firebase

class DropDownViewModel: ObservableObject{
    @Published var friends = [User] ()
    @Published var requestList = [User] ()
    @Published var pendingList = [User] ()
    @Published var friendsOfFriends = [String: Int]()
    @Published var suggestionUsers = [User: Int] ()

    @Published var friendSearchList: [User] = []
    @Published var requestSearchList: [User] = []
    @Published var pendingSearchList: [User] = []
    @Published var searchExistUsers = [User] ()

    @Published var username = String()
    @Published var uid = String()
    @Published private var userData = [String: Any]()
    @Published private var currentUserData = [String: Any]()
       
    @MainActor
    init(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        self.uid = uid
        Task{
            try await fetchFriends()
            try await fetchAllRequest()
            try await fetchAllPendings()
            try await fetchFriendsOfFriends()
        }
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
    func fetchAllPendings() async throws{
        self.pendingList = []

        let querySnapshot = try await Firestore.firestore().collection("user").document(uid).collection("pendingRequests").getDocuments()
        
        if querySnapshot.isEmpty{
            self.pendingList = []
        }
        else{
            for document in querySnapshot.documents {
                if let stringValue = document.data()["ownerUID"] as? String {
                    let pendingUsers = try await UserService.fetchUser(withUid: stringValue)
                    self.pendingList.append(pendingUsers)
                }
            }
            
        }
    }
    
    @MainActor
    func removeFriend(toUser: User) async throws{

        let currentUserFriendList = Firestore.firestore().collection("user").document(uid).collection("friends").document(toUser.id)
        let userFriendRef = Firestore.firestore().collection("user").document(toUser.id).collection("friends").document(uid)
       
        Task{
            try await currentUserFriendList.delete()
            try await userFriendRef.delete()
            
        }
        
    }
    
    
    @MainActor
    func searchFriendFunc(username: String){
        friendSearchList = []
        for i in 0 ..< friends.count {
            if(friends[i].username.contains(username)){
                friendSearchList.append(friends[i])
            }
        }
    }
    
    @MainActor
    func searchRequestListFunc(username: String){
       requestSearchList = []
    
        for i in 0 ..< requestList.count {
            if(requestList[i].username.contains(username)){
                requestSearchList.append(requestList[i])
            }
        }
    }
    
    @MainActor
    func searchPendingListFunc(username: String) {
        pendingSearchList = []
    
        for i in 0 ..< pendingList.count {
            if(pendingList[i].username.contains(username)){
                pendingSearchList.append(pendingList[i])
            }
        }
    }
    
    @MainActor
    func searchFunc(username: String) async throws -> [User]{
        var searchExistUsers: [User] = []
        
        let mergeArray = friends + requestList + pendingList
            
        let snapshot = try await Firestore.firestore().collection("user").whereField("username", isGreaterThanOrEqualTo: username).getDocuments()
        var tempArray = try snapshot.documents.compactMap({ try $0.data(as: User.self)})
        
        tempArray.removeAll{ mergeArray.contains($0)}
        
        for i in 0 ..< tempArray.count {
            if(tempArray[i].username.contains(username)){
                searchExistUsers.append(tempArray[i])
            }
        }
        
        return searchExistUsers
    }
    
    
    
    
    @MainActor
    func addFriend(toUser: User) async throws{
//        self.friends = []
        let currentUserFriendList = Firestore.firestore().collection("user").document(uid).collection("friends").document(toUser.id)
        let userFriendList = Firestore.firestore().collection("user").document(toUser.id).collection("friends").document(uid)

        currentUserData["ownerUID"] = toUser.id
        userData["ownerUID"] = uid
       
        Task{
            try await currentUserFriendList.setData(currentUserData)
            try await userFriendList.setData(userData)
            try await removeFriendRequest(toUser: toUser)
        }
    }
    
    @MainActor
    func removeFriendRequest(toUser: User) async throws{
                        
        let pendingRequestsRef = Firestore.firestore().collection("user").document(toUser.id).collection("pendingRequests").document(uid)
        let requestListRef = Firestore.firestore().collection("user").document(uid).collection("requestList").document(toUser.id)
       
        Task{
            try await requestListRef.delete()
            try await pendingRequestsRef.delete()
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
        
        Task{
            try await requestListRef.setData(userData)
            try await pendingRequestsRef.setData(currentUserData)
//            try await fetchAllPendings()
//            try await fetchFriendsOfFriends()
        }
        
    }
    
    @MainActor
    func removeFriendPending(toUser: User) async throws{
                        
        let requestListRef = Firestore.firestore().collection("user").document(toUser.id).collection("requestList").document(uid)
        let pendingRequestsRef = Firestore.firestore().collection("user").document(uid).collection("pendingRequests").document(toUser.id)
       
        Task{
            try await requestListRef.delete()
            try await pendingRequestsRef.delete()
//            try await fetchAllPendings()
//            try await fetchFriendsOfFriends()
        }
    }
    
    @MainActor
    func fetchSuggestionUsers() async throws{
        let mergeArray = friends + requestList + pendingList
        var tempArray = [User: Int]()
        
        for (key,value) in friendsOfFriends {
            let requestUsers = try await UserService.fetchUser(withUid: key)
            tempArray[requestUsers] = value
        }
        
        for key in mergeArray{
            tempArray.removeValue(forKey: key)
        }
        
        self.suggestionUsers = tempArray
        
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
    
}

