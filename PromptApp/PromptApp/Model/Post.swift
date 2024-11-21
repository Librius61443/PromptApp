//
//  Post.swift
//  PromptApp
//
//  Created by librius on 2024-01-26.
//

import Foundation
import Firebase

struct Post: Identifiable, Hashable, Codable{
    let id: String
    let ownerUID: String
    let caption: String
    var imageURL: String?
    var promt: String
    var likes: Int
    let timeStamp: Timestamp
    var user: User?

}

extension Post {
    static var Mock_Post: [Post] = [
        .init(
            id: NSUUID().uuidString,
            ownerUID: NSUUID().uuidString,
            caption: "mock caption",
            imageURL: nil,
            promt: "mock prompt",
            likes: 0,
            timeStamp: Timestamp(),
            user: User.Mock_User[0]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUID: NSUUID().uuidString,
            caption: "mock caption",
            imageURL: nil,
            promt: "mock prompt",
            likes: 0,
            timeStamp: Timestamp(),
            user: User.Mock_User[0]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUID: NSUUID().uuidString,
            caption: "mock caption",
            imageURL: nil,
            promt: "mock prompt",
            likes: 0,
            timeStamp: Timestamp(),
            user: User.Mock_User[0]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUID: NSUUID().uuidString,
            caption: "mock caption",
            imageURL: nil,
            promt: "mock prompt",
            likes: 0,
            timeStamp: Timestamp(),
            user: User.Mock_User[0]
        ),
    ]
}
