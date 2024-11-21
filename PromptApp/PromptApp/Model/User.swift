//
//  User.swift
//  PromptApp
//
//  Created by librius on 2024-01-21.
//

import Foundation
import Firebase

struct User: Identifiable, Hashable, Codable{
    var username: String
    var fullname: String?
    var profileImageURL: String?
    let email: String
    let id: String
    let currentPrompt: String
    var friends: [String]?
    var pendingRequests: [String]?
    var requestList: [String]?
    var recentPrompts: [String]?
    let promptDate: Timestamp


    var isCurrentUser: Bool{
        guard let currentUID = Auth.auth().currentUser?.uid else {return false}
        return currentUID == id
    }
}

extension User {
    static var Mock_User: [User] = [
        .init(
            username: "Batman34",
            fullname: "Bat Man",
            profileImageURL: nil,
            email: "batman@gmail.com",
            id: NSUUID().uuidString,
            currentPrompt: "",
            friends: [],
            pendingRequests: [],
            promptDate: Timestamp()),
        
        .init(
            username: "Ironman29",
            fullname: "iron Man",
            profileImageURL: nil,
            email: "ironman@gmail.com",
            id: NSUUID().uuidString,
            currentPrompt: "",
            friends: [],
            pendingRequests: [],
            promptDate: Timestamp()),
        .init(
            username: "Blackpanther89",
            fullname: "Black Panther",
            profileImageURL: nil,
            email: "blackpanter89@gmail.com",
            id: NSUUID().uuidString,
            currentPrompt: "",
            friends: [],
            pendingRequests: [],
            promptDate: Timestamp()),
        .init(
            username: "DoctorStrange",
            fullname: "Steven Strange",
            profileImageURL: nil,
            email: "Dcstrange@gmail.com",
            id: NSUUID().uuidString,
            currentPrompt: "",
            friends: [],
            pendingRequests: [],
            promptDate: Timestamp()),
        .init(
            username: "DoctorStrange",
            fullname: "Steven Strange",
            profileImageURL: nil,
            email: "Dcstrange@gmail.com",
            id: NSUUID().uuidString,
            currentPrompt: "",
            friends: [],
            pendingRequests: [],
            promptDate: Timestamp()),
    ]
}
