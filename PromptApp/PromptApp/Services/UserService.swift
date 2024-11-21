//
//  UserService.swift
//  PromptApp
//
//  Created by librius on 2024-02-09.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserService{

    static func fetchAllUsers() async throws -> [User]{
        let snapshot = try await Firestore.firestore().collection("user").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self)})
    }
    
    static func fetchUser(withUid userID: String) async throws -> User{
        let snapshot = try await Firestore.firestore().collection("user").document(userID).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchFriends(withUid userID: String) async throws -> [String]{
        var stringArray: [String] = []

        let snapshot = try await Firestore.firestore().collection("user").document(userID).collection("friends").getDocuments()
//        stringArray = try snapshot.documents.compactMap({ try $0.data(as: String.self)})
        
        for document in snapshot.documents {
                if let stringValue = document.data()["ownerUID"] as? String {
                    stringArray.append(stringValue)
                }
            }
        
        return stringArray
    }
    
    static func resetPrompt(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let updateRecentPrompts = Firestore.firestore().collection("user").document(uid)
        var data = [String: Any]()
        
        data["currentPrompt"] = ""
        
        updateRecentPrompts.updateData(data)
    }
    
    static func fetchPromptPost(withUid userID: String) async throws -> Post{
        var id: [String] = []
        
        do{
            
            let collectionRef = try await Firestore.firestore().collection("PromptPosts").order(by: "timeStamp", descending: true).limit(to: 1).getDocuments()
            
            for document in collectionRef.documents {
                    if let stringValue = document.data()["id"] as? String {
                        id.append(stringValue)
                    }
                }
            
        } catch {
            print ("failed post fetching")
        }
        
            
        let snapshot = try await Firestore.firestore().collection("user").document(userID).collection("PromptPosts").document(id[0]).getDocument()
        
        return try snapshot.data(as: Post.self)

    }
}

